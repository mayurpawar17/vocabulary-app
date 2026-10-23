import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthFailure,
      listener: (context, state) {
        if (state case AuthFailure(:final message)) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E293B),
          elevation: 0,
          title: const Text('Profile', style: TextStyle(color: Colors.white70)),
          actions: [
            IconButton(
              tooltip: 'Sign out',
              onPressed: () =>
                  context.read<AuthBloc>().add(const SignOutRequested()),
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: const Center(child: Text('This is the profile page.')),
      ),
    );
  }
}