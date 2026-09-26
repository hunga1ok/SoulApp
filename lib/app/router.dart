import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/session_controller.dart';
import '../features/auth/session_restore_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/onboarding/onboarding_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/today/today_screen.dart';
import '../features/vision/vision_screen.dart';
import 'app_state.dart';

const _entryRoutes = {'/splash', '/language', '/auth', '/onboarding/name'};

final routerProvider = Provider<GoRouter>((ref) {
  final state = ref.read(appStateProvider);
  final sessionChanges = ValueNotifier(0);
  // Re-run guards only when a routing input changes, not on every profile
  // edit (a refresh while a pushed route pops would restore that route).
  ref.listen(
    sessionControllerProvider.select(
      (session) => (
        session.isLoading,
        session.hasError,
        session.valueOrNull?.profile.hasPreferredName,
      ),
    ),
    (_, _) => sessionChanges.value++,
  );
  ref.onDispose(sessionChanges.dispose);

  String? only(String path, String target) => path == target ? null : target;

  final router = GoRouter(
    initialLocation: '/language',
    refreshListenable: Listenable.merge([state, sessionChanges]),
    redirect: (context, route) {
      final path = route.matchedLocation;
      final session = ref.read(sessionControllerProvider);
      if (session.isLoading || session.hasError) return only(path, '/splash');

      final me = session.value;
      if (me == null) {
        return state.locale == null
            ? only(path, '/language')
            : only(path, '/auth');
      }
      if (!me.profile.hasPreferredName) return only(path, '/onboarding/name');
      if (_entryRoutes.contains(path)) return '/app/today';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, route) => const SessionRestoreScreen(),
      ),
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
        routes: [
          GoRoute(
            path: 'name',
            builder:
                (context, route) => const PreferredNameScreen(isEditing: true),
          ),
        ],
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
