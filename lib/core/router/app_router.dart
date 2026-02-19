import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmanager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskmanager/features/auth/presentation/pages/login_screen.dart';
import 'package:taskmanager/features/auth/presentation/pages/registration_screen.dart';
import 'package:taskmanager/features/project/presentation/bloc/project_bloc.dart';
import 'package:taskmanager/features/project/presentation/pages/projects_screen.dart';
import 'package:taskmanager/features/splash_screen.dart';

import 'package:taskmanager/core/di/service_locator.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static const String splash = '/';
  static const String projects = '/porject';
  static const String logIn = '/login';
  static const String signUp = "/signup";

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: logIn,
        builder: (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(), child: LoginScreen()),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(), child: RegistrationScreen()),
      ),
      GoRoute(
          path: projects,
          builder: (context, state) => BlocProvider(
                create: (context) => sl<ProjectBloc>(),
                child: ProjectsScreen(),
              )),
      GoRoute(
        path: splash,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SplashScreen(),
        ),
      ),
      // GoRoute(path: home, builder: (context, state) => const HomeScreen()),
    ],
  );

  static void goSplash(BuildContext context) => context.go(splash);
  static void goLogin(BuildContext context) => context.go(logIn);
  static void pushSignUp(BuildContext context) => context.push(signUp);

  static void goProjectScreen(BuildContext context) => context.go(projects);
}
