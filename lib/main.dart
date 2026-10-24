import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabulary_app/core/app/app_router.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabulary_app/features/auth/auth_router_refresh_notifier.dart';
import 'package:vocabulary_app/features/auth/data/remoteDataSource/auth_remote_data_source.dart';
import 'package:vocabulary_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/login_use_case.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/logout_use_case.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/register_use_case.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/watch_auth_state_use_case.dart';
import 'package:vocabulary_app/features/vocabulary/data/datasources/flutter_tts_speech_data_source.dart';
import 'package:vocabulary_app/features/vocabulary/data/repositories/speech_repository_impl.dart';
import 'package:vocabulary_app/features/vocabulary/domain/repositories/speech_repository.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/pronounce_word_use_case.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/stop_speech_use_case.dart';
import 'package:vocabulary_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final AuthRouterRefreshNotifier _refreshNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    final AuthRepository authRepository = AuthRepositoryImpl(
      FirebaseAuthRemoteDataSource(FirebaseAuth.instance),
    );
    _authBloc = AuthBloc(
      loginUseCase: LoginUseCase(authRepository),
      logoutUseCase: LogoutUseCase(authRepository),
      registerUseCase: RegisterUseCase(authRepository),
      watchAuthStateUseCase: WatchAuthStateUseCase(authRepository),
    );

    _refreshNotifier = AuthRouterRefreshNotifier(_authBloc);

    final SpeechRepository speechRepository = SpeechRepositoryImpl(
      FlutterTtsSpeechDataSource(),
    );
    _router = AppRouter.createRouter(
      authBloc: _authBloc,
      refreshNotifier: _refreshNotifier,
      pronounceWord: PronounceWordUseCase(speechRepository),
      stopSpeech: StopSpeechUseCase(speechRepository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Vocabulary App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFEB4B33),
          ).copyWith(primary: const Color(0xFFEB4B33)),
          primaryColor: const Color(0xFFEB4B33),
        ),
        routerConfig: _router,
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _refreshNotifier.dispose();
    _authBloc.close();

    super.dispose();
  }
}
