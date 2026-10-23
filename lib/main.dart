import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabulary_app/core/app/app_router.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabulary_app/features/auth/auth_router_refresh_notifier.dart';
import 'package:vocabulary_app/features/auth/data/remoteDataSource/auth_remote_data_source.dart';
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

    _authBloc = AuthBloc(
      AuthRemoteDataSource(FirebaseAuth.instance),
    );

    _refreshNotifier = AuthRouterRefreshNotifier(_authBloc);

    _router = AppRouter.createRouter(
      authBloc: _authBloc,
      refreshNotifier: _refreshNotifier,
    );

    // If your AuthBloc requires an explicit initial
    // session-check event, dispatch it here.
    // _authBloc.add(const CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Vocabulary App',
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

