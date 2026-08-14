import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  static const ROUTE_PATH = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const Scaffold(body: LoginBody()),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(HomePage.ROUTE_PATH);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const .all(24),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                const SizedBox(height: 60),
                const Text(
                  AppStrings.login,
                  style: AppTextStyles.heading1,
                  textAlign: .center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back! Please sign in to continue.',
                  style: AppTextStyles.body.copyWith(color: Colors.grey),
                  textAlign: .center,
                ),
                const SizedBox(height: 40),
                if (state is AuthError) ...[
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                ],
                AuthForm(
                  isLogin: true,
                  isLoading: state is AuthLoading,
                  onSubmit: (email, password) {
                    context.read<AuthBloc>().add(
                      AuthSignInRequested(email: email, password: password),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: AppStrings.dontHaveAccount,
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push(RegisterPage.ROUTE_PATH),
                        text: AppStrings.signUp,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: .center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
