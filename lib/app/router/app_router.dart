import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../injection_container.dart';

const authRoutes = [LoginPage.ROUTE_PATH, RegisterPage.ROUTE_PATH];

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    refreshListenable: sl<AuthBloc>(),
    initialLocation: LoginPage.ROUTE_PATH,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: LoginPage.ROUTE_PATH,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.ROUTE_PATH,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: HomePage.ROUTE_PATH,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}

String? _redirect(BuildContext context, GoRouterState state) {
  final authState = sl<AuthBloc>().state;
  final isAuthRoute = authRoutes.contains(state.fullPath);
  if (authState is! AuthAuthenticated && !isAuthRoute) {
    return LoginPage.ROUTE_PATH;
  } else if (authState is AuthAuthenticated && isAuthRoute) {
    return HomePage.ROUTE_PATH;
  }
  return null;
}
