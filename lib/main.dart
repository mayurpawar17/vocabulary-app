import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabulary_app/features/auth/presentation/pages/auth_pages.dart';
import 'package:vocabulary_app/features/auth/auth_router_refresh_notifier.dart';
import 'package:vocabulary_app/features/auth/data/remoteDataSource/auth_remote_data_source.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:vocabulary_app/firebase_options.dart';
import 'package:vocabulary_app/features/vocabulary/presentation/pages/vocabulary_feed_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const _AppRoot());
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late final AuthBloc _authBloc;
  late final AuthRouterRefreshNotifier _routerRefreshNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(AuthRemoteDataSource(FirebaseAuth.instance));
    _routerRefreshNotifier = AuthRouterRefreshNotifier(_authBloc);
    _router = GoRouter(
      initialLocation: '/loading',
      refreshListenable: _routerRefreshNotifier,
      redirect: (context, state) {
        final location = state.matchedLocation;
        switch (_authBloc.state) {
          case AuthLoading():
            return location == '/loading' ? null : '/loading';
          case AuthUnauthenticated():
            if (location == '/login' || location == '/register') return null;
            return '/login';
          case AuthAuthenticated():
            return location == '/home' ? null : '/home';
          case AuthSubmitting() || AuthFailure():
            return location == '/loading' ? '/login' : null;
          case AuthState():
            return null;
        }
      },
      routes: [
        GoRoute(
          path: '/loading',
          builder: (context, state) => const _LoadingPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const VocabularyFeedPage(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _routerRefreshNotifier.dispose();
    _authBloc.close();
    super.dispose();
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FC),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
    );
  }
}
