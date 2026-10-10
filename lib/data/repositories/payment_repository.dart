import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_state.dart';
import '../../features/payment/subscription_state.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return PaymentRepository(prefs);
});

class PaymentRepository {
  PaymentRepository(this._prefs);

  static const _subKey = 'soul_subscription_state_v1';
  final SharedPreferences _prefs;

  SubscriptionState get currentSubscription {
    final raw = _prefs.getString(_subKey);
    if (raw != null) {
      try {
        final sub = SubscriptionState.fromJson(raw);
        return _evaluateExpiry(sub);
      } catch (_) {}
    }
    // Check legacy plan if set in AppState
    final legacyPlan = _prefs.getString('subscription_plan');
    if (legacyPlan != null && legacyPlan != 'free') {
      return SubscriptionState(
        planId: legacyPlan,
        isPremium: true,
        purchasedAt: DateTime.now(),
        expiresAt:
            legacyPlan == 'lifetime'
                ? null
                : DateTime.now().add(const Duration(days: 365)),
        status: SubscriptionStatus.active,
        isAutoRenew: legacyPlan != 'lifetime',
      );
    }
    return SubscriptionState.free;
  }

  SubscriptionState _evaluateExpiry(SubscriptionState sub) {
    if (sub.isLifetime) return sub;
    final now = DateTime.now();

    // Check if 7-day trial ended
    if (sub.isTrialActive && sub.trialEndsAt != null) {
      if (now.isAfter(sub.trialEndsAt!)) {
        if (sub.isAutoRenew) {
          // Converted automatically from trial to paid period!
          final duration =
              sub.planId == 'monthly'
                  ? const Duration(days: 30)
                  : const Duration(days: 365);
          return sub.copyWith(
            isTrialActive: false,
            status: SubscriptionStatus.active,
            expiresAt: now.add(duration),
          );
        } else {
          // Trial ended and user cancelled before charge
          return sub.copyWith(
            isTrialActive: false,
            isPremium: false,
            status: SubscriptionStatus.expired,
          );
        }
      }
    }

    // Check if regular cycle ended
    if (sub.expiresAt != null && now.isAfter(sub.expiresAt!)) {
      if (sub.isAutoRenew) {
        // Auto-renewed!
        final duration =
            sub.planId == 'monthly'
                ? const Duration(days: 30)
                : const Duration(days: 365);
        return sub.copyWith(
          status: SubscriptionStatus.active,
          expiresAt: now.add(duration),
        );
      } else {
        // Expired after cancellation
        return sub.copyWith(
          isPremium: false,
          status: SubscriptionStatus.expired,
        );
      }
    }

    return sub;
  }

  Future<void> saveSubscription(SubscriptionState state) async {
    await _prefs.setString(_subKey, state.toJson());
    await _prefs.setString('subscription_plan', state.planId);
  }

  Future<SubscriptionState> purchasePlan(String planId) async {
    final now = DateTime.now();
    DateTime? expiresAt;
    if (planId == 'monthly') {
      expiresAt = now.add(const Duration(days: 30));
    } else if (planId == 'yearly') {
      expiresAt = now.add(const Duration(days: 365));
    }

    final updated = SubscriptionState(
      planId: planId,
      isPremium: true,
      status: SubscriptionStatus.active,
      purchasedAt: now,
      expiresAt: expiresAt,
      isTrialActive: false,
      isAutoRenew: planId != 'lifetime',
    );
    await saveSubscription(updated);
    return updated;
  }

  Future<SubscriptionState> startFreeTrial(String planId) async {
    final now = DateTime.now();
    final trialEnds = now.add(const Duration(days: 7));
    final updated = SubscriptionState(
      planId: planId,
      isPremium: true,
      status: SubscriptionStatus.trialing,
      purchasedAt: now,
      expiresAt: trialEnds,
      isTrialActive: true,
      trialEndsAt: trialEnds,
      isAutoRenew: true,
    );
    await saveSubscription(updated);
    return updated;
  }

  Future<SubscriptionState> cancelAutoRenewal() async {
    final current = currentSubscription;
    final updated = current.copyWith(
      isAutoRenew: false,
      status: SubscriptionStatus.cancelled,
    );
    await saveSubscription(updated);
    return updated;
  }

  Future<SubscriptionState> resumeAutoRenewal() async {
    final current = currentSubscription;
    final updated = current.copyWith(
      isAutoRenew: true,
      status:
          current.isTrial
              ? SubscriptionStatus.trialing
              : SubscriptionStatus.active,
    );
    await saveSubscription(updated);
    return updated;
  }

  Future<SubscriptionState> switchPlan(String newPlanId) async {
    if (newPlanId == 'lifetime') {
      return purchasePlan(newPlanId);
    }
    final current = currentSubscription;
    final now = DateTime.now();
    final duration =
        newPlanId == 'monthly'
            ? const Duration(days: 30)
            : const Duration(days: 365);
    final updated = current.copyWith(
      planId: newPlanId,
      expiresAt: now.add(duration),
      isAutoRenew: true,
      status:
          current.isTrial
              ? SubscriptionStatus.trialing
              : SubscriptionStatus.active,
    );
    await saveSubscription(updated);
    return updated;
  }

  Future<SubscriptionState?> restorePurchases() async {
    final existing = currentSubscription;
    if (existing.isPremium) {
      return existing;
    }
    // If user restored on a new device, restore their active yearly plan
    final restored = await purchasePlan('yearly');
    return restored;
  }

  Future<SubscriptionState> resetToFree() async {
    final updated = SubscriptionState.free;
    await saveSubscription(updated);
    return updated;
  }
}
