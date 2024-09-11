import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/screens.dart';

part 'go_router.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<MainRoute>(path: '/main')
class MainRoute extends GoRouteData {
  const MainRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MainScreen();
  }
}

@TypedGoRoute<ProjectRoute>(path: '/project/:id')
class ProjectRoute extends GoRouteData {
  const ProjectRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DrawScreen(id: id);
  }
}

// ----------------- Router -----------------

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/splash',
    routes: $appRoutes,
    errorBuilder: (context, state) {
      return GoRouterErrorRoute().build(context, state);
    },
  );
}

@TypedGoRoute<GoRouterErrorRoute>(path: '/error')
class GoRouterErrorRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text('Route not found ${state.uri}'),
      ),
    );
  }
}
