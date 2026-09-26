import 'package:flutter/foundation.dart';
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

const _entryRoutes = {'/language', '/onboarding/name'};

final routerProvider = Provider<GoRouter>((ref) {
  final state = ref.read(appStateProvider);
  // Re-run guards only when a routing input changes, not on every settings
  // edit (a refresh while a pushed route pops would restore that route).
  final routingChanges = ValueNotifier(0);
  var routingInputs = (state.locale != null, state.hasPreferredName);
  void onStateChanged() {
    final next = (state.locale != null, state.hasPreferredName);
    if (next == routingInputs) return;
    routingInputs = next;
    routingChanges.value++;
  }

  state.addListener(onStateChanged);
  ref.onDispose(() {
    state.removeListener(onStateChanged);
    routingChanges.dispose();
  });

  String? only(String path, String target) => path == target ? null : target;

  final router = GoRouter(
    initialLocation: '/language',
    refreshListenable: routingChanges,
    redirect: (context, route) {
      final path = route.matchedLocation;
      if (state.locale == null) return only(path, '/language');
      if (!state.hasPreferredName) return only(path, '/onboarding/name');
      if (_entryRoutes.contains(path)) return '/app/today';
      return null;
    },
    routes: [
      GoRoute(
        path: '/language',
        builder: (context, route) => const LanguageGateScreen(),
      ),
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
