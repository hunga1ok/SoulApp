import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cards/cards_screen.dart';
import '../features/comfort_zone/comfort_zone_hub_screen.dart';
import '../features/comfort_zone/comfort_zone_room_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/onboarding/onboarding_auth_screen.dart';
import '../features/onboarding/onboarding_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/today/today_screen.dart';
import '../features/vision/vision_builder_screen.dart';
import '../features/vision/vision_detail_screen.dart';
import '../data/repositories/vision_repository.dart';
import '../features/vision/vision_screen.dart';
import 'app_state.dart';

const _entryRoutes = {
  '/language',
  '/onboarding/welcome',
  '/onboarding/auth',
  '/onboarding/name',
  '/onboarding/intention',
  '/onboarding/reminders',
  '/onboarding/ready',
};

final routerProvider = Provider<GoRouter>((ref) {
  final state = ref.read(appStateProvider);
  // Re-run guards only when a routing input changes, not on every settings
  // edit (a refresh while a pushed route pops would restore that route).
  final routingChanges = ValueNotifier(0);
  (bool, bool, bool, bool, bool) inputs() => (
    state.locale != null,
    state.hasPreferredName,
    state.intentions.isNotEmpty,
    state.remindersDecided,
    state.onboardingCompleted,
  );
  var routingInputs = inputs();
  void onStateChanged() {
    final next = inputs();
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
      if (!state.onboardingCompleted) {
        if (!state.hasPreferredName) {
          if (path == '/onboarding/welcome' ||
              path == '/onboarding/auth' ||
              path == '/onboarding/name') {
            return null;
          }
          return only(path, '/onboarding/name');
        }
        if (state.intentions.isEmpty) {
          return only(path, '/onboarding/intention');
        }
        if (!state.remindersDecided) {
          return only(path, '/onboarding/reminders');
        }
        return only(path, '/onboarding/ready');
      }
      if (_entryRoutes.contains(path)) return '/app/today';
      return null;
    },
    routes: [
      GoRoute(
        path: '/language',
        builder: (context, route) => const LanguageGateScreen(),
      ),
      GoRoute(
        path: '/onboarding/welcome',
        builder: (context, route) => const WelcomeIntroScreen(),
      ),
      GoRoute(
        path: '/onboarding/auth',
        builder: (context, route) => const OnboardingAuthScreen(),
      ),
      GoRoute(
        path: '/onboarding/name',
        builder: (context, route) => const PreferredNameScreen(),
      ),
      GoRoute(
        path: '/onboarding/intention',
        builder: (context, route) => const IntentionScreen(),
      ),
      GoRoute(
        path: '/onboarding/reminders',
        builder: (context, route) => const ReminderScreen(),
      ),
      GoRoute(
        path: '/onboarding/ready',
        builder: (context, route) => const JourneyReadyScreen(),
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
      GoRoute(path: '/cards', redirect: (context, route) => '/app/cards'),
      GoRoute(
        path: '/cards/:deckId',
        builder:
            (context, route) =>
                CardsDrawScreen(deckId: route.pathParameters['deckId']!),
      ),
      GoRoute(
        path: '/comfort-zone',
        builder: (context, route) => const ComfortZoneHubScreen(),
      ),
      GoRoute(
        path: '/comfort-zone/:sceneId',
        builder:
            (context, route) => ComfortZoneRoomScreen(
              sceneId: route.pathParameters['sceneId']!,
            ),
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
                path: '/app/cards',
                builder: (context, route) => const CardDecksHubScreen(),
                routes: [
                  GoRoute(
                    path: ':deckId',
                    builder:
                        (context, route) => CardsDrawScreen(
                          deckId: route.pathParameters['deckId']!,
                        ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/vision',
                builder: (context, route) => const VisionScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, route) => const VisionBuilderScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder:
                        (context, route) => VisionDetailScreen(
                          id: route.pathParameters['id']!,
                          initialVision:
                              route.extra is Vision
                                  ? route.extra as Vision
                                  : null,
                        ),
                  ),
                ],
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
