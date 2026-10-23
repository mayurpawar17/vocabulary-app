import 'package:go_router/go_router.dart';
import 'package:vocabulary_app/features/auth/presentation/pages/login_page.dart';
import 'package:vocabulary_app/features/auth/presentation/pages/register_page.dart';

import '../../features/vocabulary/presentation/pages/vocabulary_feed_page.dart';



import 'package:flutter/material.dart';

import '../../features/auth/auth_router_refresh_notifier.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({
    required AuthBloc authBloc,
    required AuthRouterRefreshNotifier refreshNotifier,
  }) {
    return GoRouter(
      initialLocation: '/loading',
      refreshListenable: refreshNotifier,
      redirect: (context, state) {
        final location = state.matchedLocation;

        switch (authBloc.state) {
          case AuthLoading():
            return location == '/loading' ? null : '/loading';

          case AuthUnauthenticated():
            if (location == '/login' ||
                location == '/register') {
              return null;
            }
            return '/login';

          case AuthAuthenticated():
            return location == '/home' ? null : '/home';

          case AuthSubmitting():
            if (location == '/login' ||
                location == '/register') {
              return null;
            }
            return '/login';

          case AuthFailure():
            if (location == '/login' ||
                location == '/register') {
              return null;
            }
            return '/login';

          case AuthState():
            return null;
        }
      },
      routes: [
        GoRoute(
          path: '/loading',
          builder: (context, state) =>
          const _LoadingPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
          const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) =>
          const RegisterPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) =>
          const VocabularyFeedPage(),
        ),
      ],
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FC),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6366F1),
        ),
      ),
    );
  }
}
