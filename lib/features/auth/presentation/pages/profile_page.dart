import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_app/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:vocabulary_app/features/auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await AppConfirmationBottomSheet.show(
      context,
      title: 'Sign out?',
      message: 'You can sign back in anytime to continue learning.',
      confirmLabel: 'Sign out',
      imagePath: 'assets/vocabularIcon.png',
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const SignOutRequested());
    }
  }

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
        backgroundColor: const Color(0xFFF1ECDF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text('Profile'),
          actions: [
            IconButton(
              tooltip: 'Sign out',
              onPressed: () => _confirmSignOut(context),
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: const Center(child: Text('This is the profile page.')),
      ),
    );
  }
}
