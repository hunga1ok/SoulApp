import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../data/repositories/payment_repository.dart';
import 'subscription_state.dart';

final paymentControllerProvider =
    NotifierProvider<PaymentController, SubscriptionState>(
      PaymentController.new,
    );

class PaymentController extends Notifier<SubscriptionState> {
  late final PaymentRepository _repository;

  @override
  SubscriptionState build() {
    _repository = ref.watch(paymentRepositoryProvider);
    return _repository.currentSubscription;
  }

  Future<void> purchase(String planId) async {
    final updated = await _repository.purchasePlan(planId);
    state = updated;
    await ref.read(appStateProvider).saveSubscriptionPlan(planId);
  }

  Future<void> startTrial(String planId) async {
    final updated = await _repository.startFreeTrial(planId);
    state = updated;
    await ref.read(appStateProvider).saveSubscriptionPlan(planId);
  }

  Future<void> cancelAutoRenewal() async {
    final updated = await _repository.cancelAutoRenewal();
    state = updated;
  }

  Future<void> resumeAutoRenewal() async {
    final updated = await _repository.resumeAutoRenewal();
    state = updated;
  }

  Future<void> switchPlan(String newPlanId) async {
    final updated = await _repository.switchPlan(newPlanId);
    state = updated;
    await ref.read(appStateProvider).saveSubscriptionPlan(newPlanId);
  }

  Future<bool> restorePurchases() async {
    final restored = await _repository.restorePurchases();
    if (restored != null && restored.isPremium) {
      state = restored;
      await ref.read(appStateProvider).saveSubscriptionPlan(restored.planId);
      return true;
    }
    return false;
  }

  Future<void> resetToFree() async {
    final updated = await _repository.resetToFree();
    state = updated;
    await ref.read(appStateProvider).saveSubscriptionPlan('free');
  }
}
