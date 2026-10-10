import 'dart:convert';

import '../../app/app_state.dart';

enum SubscriptionStatus {
  trialing,
  active,
  cancelled, // Auto-renew turned off, but active until period end
  expired,
}

class SubscriptionState {
  const SubscriptionState({
    required this.planId,
    required this.isPremium,
    this.status = SubscriptionStatus.active,
    this.purchasedAt,
    this.expiresAt,
    this.isTrialActive = false,
    this.trialEndsAt,
    this.isAutoRenew = true,
  });

  final String planId; // 'monthly', 'yearly', 'lifetime', 'free'
  final bool isPremium;
  final SubscriptionStatus status;
  final DateTime? purchasedAt;
  final DateTime? expiresAt;
  final bool isTrialActive;
  final DateTime? trialEndsAt;
  final bool isAutoRenew;

  bool get isLifetime => planId == 'lifetime';

  bool get isFree => !isPremium || planId == 'free';

  bool get isTrial =>
      isTrialActive &&
      trialEndsAt != null &&
      trialEndsAt!.isAfter(DateTime.now());

  int get trialDaysRemaining {
    if (trialEndsAt == null) return 0;
    final diff = trialEndsAt!.difference(DateTime.now()).inHours;
    if (diff <= 0) return 0;
    return (diff / 24).ceil();
  }

  String get planTitle => switch (planId) {
    'monthly' => 'Gói Tháng (Monthly)',
    'yearly' => 'Gói Năm (Yearly)',
    'lifetime' => 'Gói Trọn Đời (Lifetime)',
    _ => 'Bản Miễn Phí (Free)',
  };

  String get planTitleShort => switch (planId) {
    'monthly' => 'Gói Tháng',
    'yearly' => 'Gói Năm',
    'lifetime' => 'Gói Trọn Đời',
    _ => 'Miễn phí',
  };

  String get planPrice => switch (planId) {
    'monthly' => r'$2 / tháng',
    'yearly' => r'$20 / năm',
    'lifetime' => r'$50 / trọn đời',
    _ => r'$0',
  };

  String localizedPlanTitle(SoulLocale locale) {
    return formatPlanTitle(planId, locale);
  }

  String localizedPrice(SoulLocale locale) {
    return formatPlanPrice(planId, locale);
  }

  static String formatPlanTitle(String planId, SoulLocale locale) {
    return switch (planId) {
      'monthly' => switch (locale) {
        SoulLocale.vi => 'Gói Tháng',
        SoulLocale.ko => '월간 플랜',
        SoulLocale.ja => '月額プラン',
        SoulLocale.fr => 'Forfait Mensuel',
        SoulLocale.zh => '月度计划',
        SoulLocale.en => 'Monthly Plan',
      },
      'yearly' => switch (locale) {
        SoulLocale.vi => 'Gói Năm',
        SoulLocale.ko => '연간 플랜',
        SoulLocale.ja => '年額プラン',
        SoulLocale.fr => 'Forfait Annuel',
        SoulLocale.zh => '年度计划',
        SoulLocale.en => 'Yearly Plan',
      },
      'lifetime' => switch (locale) {
        SoulLocale.vi => 'Gói Trọn Đời',
        SoulLocale.ko => '평생 소장 플랜',
        SoulLocale.ja => 'ライフタイムプラン',
        SoulLocale.fr => 'Accès à Vie',
        SoulLocale.zh => '终身计划',
        SoulLocale.en => 'Lifetime Plan',
      },
      _ => switch (locale) {
        SoulLocale.vi => 'Bản Miễn phí',
        SoulLocale.ko => '무료 플랜',
        SoulLocale.ja => '無料プラン',
        SoulLocale.fr => 'Forfait Gratuit',
        SoulLocale.zh => '免费计划',
        SoulLocale.en => 'Free Plan',
      },
    };
  }

  static String formatPlanPrice(String planId, SoulLocale locale) {
    return switch (planId) {
      'monthly' => switch (locale) {
        SoulLocale.vi => r'$2 / tháng',
        SoulLocale.ko => r'$2 / 월',
        SoulLocale.ja => r'$2 / 月',
        SoulLocale.fr => r'$2 / mois',
        SoulLocale.zh => r'$2 / 月',
        SoulLocale.en => r'$2 / month',
      },
      'yearly' => switch (locale) {
        SoulLocale.vi => r'$20 / năm',
        SoulLocale.ko => r'$20 / 년',
        SoulLocale.ja => r'$20 / 年',
        SoulLocale.fr => r'$20 / an',
        SoulLocale.zh => r'$20 / 年',
        SoulLocale.en => r'$20 / year',
      },
      'lifetime' => switch (locale) {
        SoulLocale.vi => r'$50 / trọn đời',
        SoulLocale.ko => r'$50 / 평생',
        SoulLocale.ja => r'$50 / 永久',
        SoulLocale.fr => r'$50 / à vie',
        SoulLocale.zh => r'$50 / 终身',
        SoulLocale.en => r'$50 / lifetime',
      },
      _ => r'$0',
    };
  }

  SubscriptionState copyWith({
    String? planId,
    bool? isPremium,
    SubscriptionStatus? status,
    DateTime? purchasedAt,
    DateTime? expiresAt,
    bool? isTrialActive,
    DateTime? trialEndsAt,
    bool? isAutoRenew,
  }) {
    return SubscriptionState(
      planId: planId ?? this.planId,
      isPremium: isPremium ?? this.isPremium,
      status: status ?? this.status,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      isAutoRenew: isAutoRenew ?? this.isAutoRenew,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planId': planId,
      'isPremium': isPremium,
      'status': status.name,
      'purchasedAt': purchasedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isTrialActive': isTrialActive,
      'trialEndsAt': trialEndsAt?.toIso8601String(),
      'isAutoRenew': isAutoRenew,
    };
  }

  factory SubscriptionState.fromMap(Map<String, dynamic> map) {
    final statusName = map['status'] as String?;
    final parsedStatus =
        statusName != null
            ? SubscriptionStatus.values.firstWhere(
              (e) => e.name == statusName,
              orElse: () => SubscriptionStatus.active,
            )
            : ((map['isTrialActive'] as bool? ?? false)
                ? SubscriptionStatus.trialing
                : SubscriptionStatus.active);

    return SubscriptionState(
      planId: map['planId'] as String? ?? 'free',
      isPremium: map['isPremium'] as bool? ?? false,
      status: parsedStatus,
      purchasedAt: DateTime.tryParse(map['purchasedAt'] as String? ?? ''),
      expiresAt: DateTime.tryParse(map['expiresAt'] as String? ?? ''),
      isTrialActive: map['isTrialActive'] as bool? ?? false,
      trialEndsAt: DateTime.tryParse(map['trialEndsAt'] as String? ?? ''),
      isAutoRenew: map['isAutoRenew'] as bool? ?? true,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory SubscriptionState.fromJson(String source) =>
      SubscriptionState.fromMap(jsonDecode(source) as Map<String, dynamic>);

  static const free = SubscriptionState(
    planId: 'free',
    isPremium: false,
    status: SubscriptionStatus.expired,
    isAutoRenew: false,
  );
}
