import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/explore/explore_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/onboarding/onboarding_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/today/today_screen.dart';
import '../features/vision/vision_screen.dart';
import 'app_state.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final state = ref.read(appStateProvider);

  final router = GoRouter(
    initialLocation: '/language',
    refreshListenable: state,
    redirect: (context, route) {
      final path = route.matchedLocation;
      if (state.locale == null) {
        return path == '/language' ? null : '/language';
      }
      if (!state.isAuthenticated) {
        return path == '/auth' ? null : '/auth';
      }
      if (!state.hasCompletedName) {
        return path == '/onboarding/name' ? null : '/onboarding/name';
      }
      if (path == '/language' ||
          path == '/auth' ||
          path == '/onboarding/name') {
        return '/app/today';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/language',
        builder: (context, route) => const LanguageGateScreen(),
      ),
      GoRoute(path: '/auth', builder: (context, route) => const AuthScreen()),
      GoRoute(
        path: '/onboarding/name',
        builder: (context, route) => const PreferredNameScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, route) => const ProfileScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/today',
                builder: (context, route) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/vision',
                builder: (context, route) => const VisionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/journal',
                builder: (context, route) => const JournalScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/explore',
                builder: (context, route) => const ExploreScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
