import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../injection_container.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    refreshListenable: sl<AuthBloc>(),
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: LoginPage.ROUTE_NAME,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: RegisterPage.ROUTE_NAME,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home — replace with your home page')),
        ),
      ),
    ],
    redirect: (context, state) {
      final state = sl<AuthBloc>().state;
      if (state is! AuthAuthenticated) {
        return '/login';
      }
      return null;
    },
  );
}
