import 'package:go_router/go_router.dart';
import 'package:vocabulary_app/features/auth/presentation/pages/login_page.dart';
import 'package:vocabulary_app/features/auth/presentation/pages/register_page.dart';

import '../../features/vocabulary/domain/usecases/pronounce_word_use_case.dart';
import '../../features/vocabulary/domain/usecases/stop_speech_use_case.dart';
import '../../features/home/presentation/pages/app_shell.dart';

import 'package:flutter/material.dart';

import '../../features/auth/auth_router_refresh_notifier.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({
    required AuthBloc authBloc,
    required AuthRouterRefreshNotifier refreshNotifier,
    required PronounceWordUseCase pronounceWord,
    required StopSpeechUseCase stopSpeech,
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
            if (location == '/login' || location == '/register') {
              return null;
            }
            return '/login';

          case AuthAuthenticated():
            if (location == '/profile') {
              return '/home?tab=profile';
            }
            if (location == '/login' ||
                location == '/register' ||
                location == '/loading') {
              return '/home';
            }
            return null;

          case AuthSubmitting():
            if (location == '/login' || location == '/register') {
              return null;
            }
            return '/login';

          case AuthFailure():
            if (location == '/profile') {
              return '/home?tab=profile';
            }
            if (location == '/login' ||
                location == '/register' ||
                location == '/home') {
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
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const _LoadingPage(),
          ),
          // builder: (context, state) => const _LoadingPage(),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          ),
          // builder: (context, state) => const LoginPage()
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterPage(),
          ),

          // builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: AppShell(
              pronounceWord: pronounceWord,
              stopSpeech: stopSpeech,
              initialIndex: switch (state.uri.queryParameters['tab']) {
                'practice' => 1,
                'profile' => 2,
                _ => 0,
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
