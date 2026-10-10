import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import 'payment_controller.dart';
import 'subscription_state.dart';

class BillingSubscriptionScreen extends ConsumerWidget {
  const BillingSubscriptionScreen({super.key});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(paymentControllerProvider);
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: SoulAppBar(
        title: switch (locale) {
          SoulLocale.vi => 'Gói đăng ký & Thanh toán',
          SoulLocale.ko => '구독 및 결제 관리',
          SoulLocale.ja => 'サブスクリプションと支払い',
          SoulLocale.fr => 'Abonnement & Facturation',
          SoulLocale.zh => '订阅与账单管理',
          SoulLocale.en => 'Subscription & Billing',
        },
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.lg,
          vertical: SoulSpace.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Current Plan Card
            Container(
              padding: const EdgeInsets.all(SoulSpace.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBF7), Color(0xFFFBF2E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(SoulRadius.card),
                border: Border.all(
                  color: const Color(0xFFE5C8A8).withValues(alpha: 0.9),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD99C4B).withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE0B2),
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                size: 15,
                                color: Color(0xFFB86A2E),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  sub.isFree
                                      ? (switch (locale) {
                                        SoulLocale.vi => 'CHƯA KÍCH HOẠT',
                                        SoulLocale.ko => '비활성',
                                        SoulLocale.ja => '未登録',
                                        SoulLocale.fr => 'NON ACTIF',
                                        SoulLocale.zh => '未激活',
                                        SoulLocale.en => 'INACTIVE',
                                      })
                                      : (sub.isLifetime
                                          ? (switch (locale) {
                                            SoulLocale.vi => 'TRỌN ĐỜI',
                                            SoulLocale.ko => '평생 소장',
                                            SoulLocale.ja => 'ライフタイム',
                                            SoulLocale.fr => 'À VIE',
                                            SoulLocale.zh => '终身',
                                            SoulLocale.en => 'LIFETIME',
                                          })
                                          : (!sub.isAutoRenew
                                              ? (switch (locale) {
                                                SoulLocale.vi =>
                                                  'ĐÃ HỦY GIA HẠN',
                                                SoulLocale.ko => '자동 갱신 취소됨',
                                                SoulLocale.ja => '自動更新解除済み',
                                                SoulLocale.fr =>
                                                  'RENOUVELLEMENT DÉSACTIVÉ',
                                                SoulLocale.zh => '已取消自动续订',
                                                SoulLocale.en => 'CANCELLED',
                                              })
                                              : (sub.isTrial
                                                  ? (switch (locale) {
                                                    SoulLocale.vi =>
                                                      'DÙNG THỬ 7 NGÀY',
                                                    SoulLocale.ko => '7일 무료 체험',
                                                    SoulLocale.ja => '7日間無料体験',
                                                    SoulLocale.fr =>
                                                      'ESSAI 7 JOURS',
                                                    SoulLocale.zh => '7天免费试用',
                                                    SoulLocale.en =>
                                                      '7-DAY TRIAL',
                                                  })
                                                  : (switch (locale) {
                                                    SoulLocale.vi =>
                                                      'ĐANG HOẠT ĐỘNG',
                                                    SoulLocale.ko => '구독 활성',
                                                    SoulLocale.ja => '利用中',
                                                    SoulLocale.fr => 'ACTIF',
                                                    SoulLocale.zh => '有效',
                                                    SoulLocale.en => 'ACTIVE',
                                                  })))),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFB86A2E),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: SoulSpace.sm),
                      Text(
                        sub.isFree ? r'$0' : sub.localizedPrice(locale),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: SoulColors.plum,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SoulSpace.md),
                  Text(
                    sub.isFree
                        ? (switch (locale) {
                          SoulLocale.vi => 'Chưa kích hoạt Soul Premium',
                          SoulLocale.ko => 'Soul 프리미엄 비활성 상태',
                          SoulLocale.ja => 'Soul プレミアム未登録',
                          SoulLocale.fr => 'Soul Premium non activé',
                          SoulLocale.zh => '尚未激活 Soul 高级会员',
                          SoulLocale.en => 'Soul Premium Inactive',
                        })
                        : 'Soul Premium · ${sub.localizedPlanTitle(locale)}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: SoulColors.plum,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sub.isFree
                        ? (switch (locale) {
                          SoulLocale.vi =>
                            'Chọn một gói bên dưới để bắt đầu 7 ngày dùng thử miễn phí và mở khóa toàn bộ không gian âm nhạc, Vision Board & Tần số chữa lành.',
                          SoulLocale.ko =>
                            '아래에서 플랜을 선택하여 7일 무료 체험을 시작하고 모든 안식처, 비전 보드 및 치유 주파수를 잠금 해제하세요.',
                          SoulLocale.ja =>
                            '以下のプランを選択して7日間の無料体験を開始し、すべての癒やし空間、ビジョンボード、周波数サウンドをご利用ください。',
                          SoulLocale.fr =>
                            'Choisissez un forfait ci-dessous pour démarrer 7 jours d’essai gratuit et débloquer tous les espaces de paix, Vision Board et fréquences de guérison.',
                          SoulLocale.zh =>
                            '选择下方计划开启 7 天免费试用，解锁全部心灵安宁空间、愿景板及疗愈频率音频。',
                          SoulLocale.en =>
                            'Choose a plan below to start your 7-day free trial and unlock all music spaces, Vision Board & healing frequencies.',
                        })
                        : (sub.isLifetime
                            ? (switch (locale) {
                              SoulLocale.vi =>
                                'Bạn đã sở hữu Soul Premium vĩnh viễn trên tài khoản này.',
                              SoulLocale.ko =>
                                '이 계정에서 Soul 프리미엄 평생 소장 권한을 보유하고 있습니다.',
                              SoulLocale.ja =>
                                'このアカウントでSoulプレミアムの永久アクセスを保有しています。',
                              SoulLocale.fr =>
                                'Vous disposez d’un accès à vie à Soul Premium sur ce compte.',
                              SoulLocale.zh => '此账号已享有 Soul 高级会员终身使用权。',
                              SoulLocale.en =>
                                'You have permanent lifetime access to Soul Premium.',
                            })
                            : (sub.isTrial
                                ? (sub.isAutoRenew
                                    ? (switch (locale) {
                                      SoulLocale.vi =>
                                        'Đang trong 7 ngày dùng thử miễn phí (còn ${sub.trialDaysRemaining} ngày). Gói sẽ tự động thanh toán vào ngày ${_formatDate(sub.trialEndsAt)}. Bạn có thể hủy bất cứ lúc nào trước ngày này mà không bị tính phí.',
                                      SoulLocale.ko =>
                                        '7일 무료 체험 중 (${sub.trialDaysRemaining}일 남음). ${_formatDate(sub.trialEndsAt)}에 자동으로 정기 결제됩니다. 해당 날짜 이전에 언제든지 비용 없이 취소할 수 있습니다.',
                                      SoulLocale.ja =>
                                        '7日間の無料体験中（残り${sub.trialDaysRemaining}日）。${_formatDate(sub.trialEndsAt)}に自動更新されます。この日以前であればいつでも無料で解約可能です。',
                                      SoulLocale.fr =>
                                        'Essai gratuit de 7 jours en cours (${sub.trialDaysRemaining} jours restants). Renouvellement automatique le ${_formatDate(sub.trialEndsAt)}. Résiliation sans frais possible à tout moment avant cette date.',
                                      SoulLocale.zh =>
                                        '7天免费试用中（剩余 ${sub.trialDaysRemaining} 天）。将于 ${_formatDate(sub.trialEndsAt)} 自动扣费续订。在此之前你可以随时免费取消。',
                                      SoulLocale.en =>
                                        '7-day free trial active (${sub.trialDaysRemaining} days remaining). Auto-renews on ${_formatDate(sub.trialEndsAt)}. Cancel anytime before then at no cost.',
                                    })
                                    : (switch (locale) {
                                      SoulLocale.vi =>
                                        'Đã hủy tự động gia hạn trong thời gian dùng thử (còn ${sub.trialDaysRemaining} ngày). Bạn vẫn có quyền sử dụng Soul Premium đến ngày ${_formatDate(sub.trialEndsAt)} mà không bị tính phí.',
                                      SoulLocale.ko =>
                                        '무료 체험 중 자동 갱신이 취소되었습니다 (${sub.trialDaysRemaining}일 남음). ${_formatDate(sub.trialEndsAt)}까지 추가 결제 없이 Soul 프리미엄을 계속 이용할 수 있습니다.',
                                      SoulLocale.ja =>
                                        '無料体験中の自動更新を解除しました（残り${sub.trialDaysRemaining}日）。${_formatDate(sub.trialEndsAt)}まで追加料金なしでSoulプレミアムをお使いいただけます。',
                                      SoulLocale.fr =>
                                        'Renouvellement auto annulé pendant l’essai (${sub.trialDaysRemaining} jours restants). Vous conservez l’accès à Soul Premium jusqu’au ${_formatDate(sub.trialEndsAt)} sans frais.',
                                      SoulLocale.zh =>
                                        '试用期间已取消自动续订（剩余 ${sub.trialDaysRemaining} 天）。你仍可在 ${_formatDate(sub.trialEndsAt)} 前免费享受 Soul 高级会员权益。',
                                      SoulLocale.en =>
                                        'Auto-renewal cancelled during trial (${sub.trialDaysRemaining} days remaining). Full Soul Premium access continues until ${_formatDate(sub.trialEndsAt)} with no charges.',
                                    }))
                                : (sub.isAutoRenew
                                    ? (switch (locale) {
                                      SoulLocale.vi =>
                                        'Gói sẽ tự động gia hạn vào ngày ${_formatDate(sub.expiresAt)}.',
                                      SoulLocale.ko =>
                                        '구독이 ${_formatDate(sub.expiresAt)}에 자동으로 갱신됩니다.',
                                      SoulLocale.ja =>
                                        'サブスクリプションは ${_formatDate(sub.expiresAt)} に自動更新されます。',
                                      SoulLocale.fr =>
                                        'Votre abonnement sera automatiquement renouvelé le ${_formatDate(sub.expiresAt)}.',
                                      SoulLocale.zh =>
                                        '订阅将于 ${_formatDate(sub.expiresAt)} 自动续费。',
                                      SoulLocale.en =>
                                        'Your subscription will automatically renew on ${_formatDate(sub.expiresAt)}.',
                                    })
                                    : (switch (locale) {
                                      SoulLocale.vi =>
                                        'Bạn đã tắt tự động gia hạn. Toàn bộ tính năng Soul Premium vẫn khả dụng đến hết ngày ${_formatDate(sub.expiresAt)}.',
                                      SoulLocale.ko =>
                                        '자동 갱신이 꺼져 있습니다. ${_formatDate(sub.expiresAt)}까지 Soul 프리미엄의 모든 기능을 계속 이용할 수 있습니다.',
                                      SoulLocale.ja =>
                                        '自動更新は無効になっています。${_formatDate(sub.expiresAt)}までSoulプレミアムの全機能をご利用いただけます。',
                                      SoulLocale.fr =>
                                        'Renouvellement désactivé. Toutes les fonctionnalités Soul Premium restent disponibles jusqu’au ${_formatDate(sub.expiresAt)}.',
                                      SoulLocale.zh =>
                                        '你已关闭自动续费。在 ${_formatDate(sub.expiresAt)} 之前你仍可继续使用 Soul 高级版的全部功能。',
                                      SoulLocale.en =>
                                        'Auto-renewal cancelled. You maintain full Soul Premium access until ${_formatDate(sub.expiresAt)}.',
                                    })))),
                    style: textTheme.bodySmall?.copyWith(
                      color: SoulColors.softInk,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SoulSpace.lg),

            // 2. Resume Auto-renewal banner (only when already cancelled)
            if (sub.isPremium && !sub.isLifetime && !sub.isAutoRenew) ...[
              SoulCard(
                color: const Color(0xFFF3E5F5),
                padding: const EdgeInsets.symmetric(
                  horizontal: SoulSpace.md,
                  vertical: SoulSpace.sm,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 20,
                      color: SoulColors.plum,
                    ),
                    const SizedBox(width: SoulSpace.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            switch (locale) {
                              SoulLocale.vi => 'Kích hoạt lại gia hạn',
                              SoulLocale.ko => '자동 갱신 다시 켜기',
                              SoulLocale.ja => '自動更新を再開',
                              SoulLocale.fr => 'Réactiver le renouvellement',
                              SoulLocale.zh => '恢复自动续订',
                              SoulLocale.en => 'Resume Auto-Renewal',
                            },
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: SoulColors.plum,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            switch (locale) {
                              SoulLocale.vi =>
                                'Duy trì không gian an yên không gián đoạn.',
                              SoulLocale.ko => '끊김 없이 평온한 안식처를 유지하세요.',
                              SoulLocale.ja => '途切れることなく心の安らぎを保ちます。',
                              SoulLocale.fr =>
                                'Poursuivez votre voyage de paix sans interruption.',
                              SoulLocale.zh => '不间断享受宁静的心灵安宁空间。',
                              SoulLocale.en =>
                                'Continue peace without interruption.',
                            },
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: SoulColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SoulColors.plum,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () async {
                        await ref
                            .read(paymentControllerProvider.notifier)
                            .resumeAutoRenewal();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(switch (locale) {
                                SoulLocale.vi =>
                                  'Đã kích hoạt lại tự động gia hạn thành công!',
                                SoulLocale.ko => '자동 갱신이 성공적으로 재개되었습니다!',
                                SoulLocale.ja => '自動更新を再開しました！',
                                SoulLocale.fr =>
                                  'Renouvellement automatique réactivé avec succès !',
                                SoulLocale.zh => '已成功重新开启自动续订！',
                                SoulLocale.en =>
                                  'Auto-renewal successfully reactivated!',
                              }),
                            ),
                          );
                        }
                      },
                      child: Text(switch (locale) {
                        SoulLocale.vi => 'Bật lại',
                        SoulLocale.ko => '다시 켜기',
                        SoulLocale.ja => '再開',
                        SoulLocale.fr => 'Réactiver',
                        SoulLocale.zh => '恢复',
                        SoulLocale.en => 'Resume',
                      }, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SoulSpace.lg),
            ],

            // 3. Switch Plans section (if not lifetime)
            if (!sub.isLifetime) ...[
              Text(
                sub.isFree
                    ? (switch (locale) {
                      SoulLocale.vi => 'Chọn gói bắt đầu 7 ngày dùng thử',
                      SoulLocale.ko => '7일 무료 체험 플랜 선택',
                      SoulLocale.ja => '7日間無料体験プランを選択',
                      SoulLocale.fr => 'Choisir un forfait (Essai 7 jours)',
                      SoulLocale.zh => '选择计划（7天免费试用）',
                      SoulLocale.en => 'Choose a Plan (7-Day Free Trial)',
                    })
                    : (switch (locale) {
                      SoulLocale.vi => 'Chuyển đổi gói khác',
                      SoulLocale.ko => '다른 플랜으로 변경',
                      SoulLocale.ja => 'プランを変更する',
                      SoulLocale.fr => 'Changer de forfait',
                      SoulLocale.zh => '更换其他计划',
                      SoulLocale.en => 'Switch Plans',
                    }),
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SoulColors.plum,
                ),
              ),
              const SizedBox(height: SoulSpace.xs),
              if (sub.planId != 'yearly')
                _PlanSwitchTile(
                  locale: locale,
                  title: switch (locale) {
                    SoulLocale.vi => 'Gói Năm · Tiết kiệm 17%',
                    SoulLocale.ko => '연간 플랜 · 17% 할인',
                    SoulLocale.ja => '年額プラン · 17%お得',
                    SoulLocale.fr => 'Forfait Annuel · Économisez 17%',
                    SoulLocale.zh => '年度计划 · 节省 17%',
                    SoulLocale.en => 'Yearly Plan · Save 17%',
                  },
                  price: SubscriptionState.formatPlanPrice('yearly', locale),
                  onSelect:
                      () => _confirmSwitchPlan(
                        context,
                        ref,
                        'yearly',
                        locale,
                        sub,
                      ),
                ),
              if (sub.planId != 'monthly')
                _PlanSwitchTile(
                  locale: locale,
                  title: switch (locale) {
                    SoulLocale.vi => 'Gói Tháng linh hoạt',
                    SoulLocale.ko => '유연한 월간 플랜',
                    SoulLocale.ja => 'フレキシブルな月額プラン',
                    SoulLocale.fr => 'Forfait Mensuel Flexible',
                    SoulLocale.zh => '灵活月度计划',
                    SoulLocale.en => 'Flexible Monthly Plan',
                  },
                  price: SubscriptionState.formatPlanPrice('monthly', locale),
                  onSelect:
                      () => _confirmSwitchPlan(
                        context,
                        ref,
                        'monthly',
                        locale,
                        sub,
                      ),
                ),
              _PlanSwitchTile(
                locale: locale,
                title: switch (locale) {
                  SoulLocale.vi => 'Gói Trọn Đời (Sở hữu vĩnh viễn)',
                  SoulLocale.ko => '평생 소장 플랜 (영구 소장)',
                  SoulLocale.ja => 'ライフタイムプラン（永久アクセス）',
                  SoulLocale.fr => 'Accès à Vie (Définitif)',
                  SoulLocale.zh => '终身计划（永久买断）',
                  SoulLocale.en => 'Lifetime Access (Forever)',
                },
                price: SubscriptionState.formatPlanPrice('lifetime', locale),
                badge: switch (locale) {
                  SoulLocale.vi => 'GIÁ TRỊ NHẤT',
                  SoulLocale.ko => '최고의 가치',
                  SoulLocale.ja => 'ベストバリュー',
                  SoulLocale.fr => 'MEILLEURE VALEUR',
                  SoulLocale.zh => '超值首选',
                  SoulLocale.en => 'BEST VALUE',
                },
                onSelect:
                    () => _confirmSwitchPlan(
                      context,
                      ref,
                      'lifetime',
                      locale,
                      sub,
                    ),
              ),
              const SizedBox(height: SoulSpace.lg),
            ],

            // 4. Restore Purchases
            SoulCard(
              padding: const EdgeInsets.symmetric(
                horizontal: SoulSpace.md,
                vertical: SoulSpace.sm,
              ),
              child: InkWell(
                onTap: () async {
                  final restored =
                      await ref
                          .read(paymentControllerProvider.notifier)
                          .restorePurchases();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          restored
                              ? (switch (locale) {
                                SoulLocale.vi =>
                                  'Đã khôi phục thành công gói mua của bạn!',
                                SoulLocale.ko => '구매 내역이 성공적으로 복원되었습니다!',
                                SoulLocale.ja => '購入内容を正常に復元しました！',
                                SoulLocale.fr =>
                                  'Vos achats ont été restaurés avec succès !',
                                SoulLocale.zh => '已成功恢复你的购买！',
                                SoulLocale.en =>
                                  'Purchases successfully restored!',
                              })
                              : (switch (locale) {
                                SoulLocale.vi =>
                                  'Không tìm thấy gói mua trước đó.',
                                SoulLocale.ko => '이전 구매 내역을 찾을 수 없습니다.',
                                SoulLocale.ja => '過去の購入履歴が見つかりませんでした。',
                                SoulLocale.fr =>
                                  'Aucun achat précédent trouvé.',
                                SoulLocale.zh => '未找到以往的购买记录。',
                                SoulLocale.en => 'No previous purchase found.',
                              }),
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.restore_rounded,
                      size: 20,
                      color: SoulColors.plum,
                    ),
                    const SizedBox(width: SoulSpace.sm),
                    Expanded(
                      child: Text(
                        switch (locale) {
                          SoulLocale.vi =>
                            'Khôi phục gói mua trên thiết bị này',
                          SoulLocale.ko => '이 기기에서 구매 내역 복원',
                          SoulLocale.ja => 'このデバイスで購入を復元',
                          SoulLocale.fr =>
                            'Restaurer les achats sur cet appareil',
                          SoulLocale.zh => '在此设备上恢复购买',
                          SoulLocale.en => 'Restore Purchases on this device',
                        },
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: SoulColors.muted,
                    ),
                  ],
                ),
              ),
            ),
            // 5. Subtle, non-prominent Cancel Auto-Renewal at the very bottom
            if (sub.isPremium && !sub.isLifetime && sub.isAutoRenew) ...[
              Center(
                child: TextButton(
                  onPressed:
                      () =>
                          _confirmCancelAutoRenewal(context, ref, locale, sub),
                  style: TextButton.styleFrom(
                    foregroundColor: SoulColors.muted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                  ),
                  child: Text(
                    switch (locale) {
                      SoulLocale.vi => 'Hủy tự động gia hạn gói',
                      SoulLocale.ko => '구독 자동 갱신 취소',
                      SoulLocale.ja => '自動更新の解除',
                      SoulLocale.fr => 'Désactiver le renouvellement',
                      SoulLocale.zh => '取消自动续订',
                      SoulLocale.en => 'Cancel Auto-Renewal',
                    },
                    style: const TextStyle(
                      fontSize: 12,
                      color: SoulColors.muted,
                      decoration: TextDecoration.underline,
                      decorationColor: SoulColors.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SoulSpace.sm),
            ],

            // 6. App Store & Google Play Notice
            Center(
              child: Text(
                switch (locale) {
                  SoulLocale.vi =>
                    'Thanh toán được bảo mật và quản lý tự động bởi Apple App Store / Google Play.',
                  SoulLocale.ko =>
                    '결제는 Apple App Store 및 Google Play를 통해 안전하게 처리되고 관리됩니다.',
                  SoulLocale.ja =>
                    'お支払いは Apple App Store / Google Play によって安全に管理されます。',
                  SoulLocale.fr =>
                    'Les paiements sont gérés en toute sécurité par Apple App Store / Google Play.',
                  SoulLocale.zh =>
                    '所有付款均由 Apple App Store / Google Play 进行安全管理。',
                  SoulLocale.en =>
                    'Payments are securely managed by Apple App Store / Google Play.',
                },
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: SoulColors.muted,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancelAutoRenewal(
    BuildContext context,
    WidgetRef ref,
    SoulLocale locale,
    SubscriptionState sub,
  ) async {
    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: switch (locale) {
        SoulLocale.vi => 'Hủy tự động gia hạn gói?',
        SoulLocale.ko => '자동 갱신을 취소하시겠습니까?',
        SoulLocale.ja => '自動更新を解除しますか？',
        SoulLocale.fr => 'Désactiver le renouvellement automatique ?',
        SoulLocale.zh => '确认取消自动续订吗？',
        SoulLocale.en => 'Cancel Auto-Renewal?',
      },
      message: switch (locale) {
        SoulLocale.vi =>
          'Bạn sẽ không bị trừ tiền cho chu kỳ tiếp theo. Bạn vẫn có toàn quyền sử dụng tất cả tính năng Soul Premium đến hết ngày ${_formatDate(sub.expiresAt ?? sub.trialEndsAt)}.',
        SoulLocale.ko =>
          '다음 결제 주기에 요금이 청구되지 않습니다. ${_formatDate(sub.expiresAt ?? sub.trialEndsAt)}까지 Soul 프리미엄의 모든 기능을 계속 이용할 수 있습니다.',
        SoulLocale.ja =>
          '次回の更新時に請求は発生しません。${_formatDate(sub.expiresAt ?? sub.trialEndsAt)}までSoulプレミアムのすべての機能をそのままご利用いただけます。',
        SoulLocale.fr =>
          'Vous ne serez pas débité pour la prochaine période. Vous conservez un accès complet à Soul Premium jusqu’au ${_formatDate(sub.expiresAt ?? sub.trialEndsAt)}.',
        SoulLocale.zh =>
          '下一个周期将不再扣费。在 ${_formatDate(sub.expiresAt ?? sub.trialEndsAt)} 到期之前，你仍可正常使用 Soul 高级版的全部功能。',
        SoulLocale.en =>
          'You will not be billed for the next period. Full Soul Premium access continues until ${_formatDate(sub.expiresAt ?? sub.trialEndsAt)}.',
      },
      confirmLabel: switch (locale) {
        SoulLocale.vi => 'Xác nhận hủy',
        SoulLocale.ko => '취소 확인',
        SoulLocale.ja => '解除を確定',
        SoulLocale.fr => 'Confirmer',
        SoulLocale.zh => '确认取消',
        SoulLocale.en => 'Confirm Cancel',
      },
    );

    if (confirmed) {
      await ref.read(paymentControllerProvider.notifier).cancelAutoRenewal();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(switch (locale) {
              SoulLocale.vi => 'Đã hủy tự động gia hạn thành công.',
              SoulLocale.ko => '자동 갱신이 성공적으로 취소되었습니다.',
              SoulLocale.ja => '自動更新を解除しました。',
              SoulLocale.fr => 'Le renouvellement automatique a été désactivé.',
              SoulLocale.zh => '已成功取消自动续订。',
              SoulLocale.en => 'Auto-renewal has been cancelled.',
            }),
          ),
        );
      }
    }
  }

  Future<void> _confirmSwitchPlan(
    BuildContext context,
    WidgetRef ref,
    String newPlanId,
    SoulLocale locale,
    SubscriptionState sub,
  ) async {
    final planName = SubscriptionState.formatPlanTitle(newPlanId, locale);
    final planPrice = SubscriptionState.formatPlanPrice(newPlanId, locale);
    final planTitleWithPrice = '$planName ($planPrice)';

    final isStartingNew = sub.isFree;

    final title =
        isStartingNew
            ? (newPlanId == 'lifetime'
                ? (switch (locale) {
                  SoulLocale.vi => 'Mua $planTitleWithPrice?',
                  SoulLocale.ko => '$planTitleWithPrice 구매?',
                  SoulLocale.ja => '$planTitleWithPrice を購入しますか？',
                  SoulLocale.fr => 'Acheter $planTitleWithPrice ?',
                  SoulLocale.zh => '购买 $planTitleWithPrice？',
                  SoulLocale.en => 'Purchase $planTitleWithPrice?',
                })
                : (switch (locale) {
                  SoulLocale.vi =>
                    'Bắt đầu 7 ngày dùng thử ($planTitleWithPrice)?',
                  SoulLocale.ko => '7일 무료 체험 시작 ($planTitleWithPrice)?',
                  SoulLocale.ja => '7日間の無料体験を開始 ($planTitleWithPrice)?',
                  SoulLocale.fr =>
                    'Commencer l’essai gratuit de 7 jours ($planTitleWithPrice) ?',
                  SoulLocale.zh => '开启 7 天免费试用（$planTitleWithPrice）？',
                  SoulLocale.en =>
                    'Start 7-Day Free Trial ($planTitleWithPrice)?',
                }))
            : (switch (locale) {
              SoulLocale.vi => 'Chuyển sang $planTitleWithPrice?',
              SoulLocale.ko => '$planTitleWithPrice(으)로 변경하시겠습니까?',
              SoulLocale.ja => '$planTitleWithPrice に変更しますか？',
              SoulLocale.fr => 'Passer au $planTitleWithPrice ?',
              SoulLocale.zh => '切换至 $planTitleWithPrice？',
              SoulLocale.en => 'Switch to $planTitleWithPrice?',
            });

    final message =
        isStartingNew
            ? (newPlanId == 'lifetime'
                ? (switch (locale) {
                  SoulLocale.vi =>
                    'Sở hữu trọn đời toàn bộ tính năng và âm nhạc của Soul App.',
                  SoulLocale.ko => 'Soul App의 모든 기능과 힐링 음악을 평생 소장합니다.',
                  SoulLocale.ja => 'Soul Appの全機能と音楽を永久にご利用いただけます。',
                  SoulLocale.fr =>
                    'Accès à vie à toutes les fonctionnalités et musiques de Soul App.',
                  SoulLocale.zh => '终身永久拥有 Soul App 的所有功能与疗愈音乐。',
                  SoulLocale.en =>
                    'Permanent access to all Soul App features and music.',
                })
                : (switch (locale) {
                  SoulLocale.vi =>
                    'Trải nghiệm 7 ngày đầu hoàn toàn miễn phí. Sau 7 ngày tự động gia hạn với mức phí đã chọn. Bạn có thể hủy bất cứ lúc nào trước đó.',
                  SoulLocale.ko =>
                    '첫 7일간 완전 무료로 체험하세요. 7일 후 선택한 플랜으로 자동 결제됩니다. 언제든지 취소 가능합니다.',
                  SoulLocale.ja =>
                    '最初の7日間は完全無料でお試しいただけます。7日後に自動更新されます。それ以前にいつでも解約可能です。',
                  SoulLocale.fr =>
                    'Profitez de vos 7 premiers jours gratuits. Renouvellement automatique ensuite. Résiliation possible à tout moment avant.',
                  SoulLocale.zh => '首周 7 天完全免费体验。7天后将按所选方案自动续订。在此之前可随时取消。',
                  SoulLocale.en =>
                    'Enjoy your first 7 days free. Auto-renews afterwards. Cancel anytime before to avoid charges.',
                }))
            : (switch (locale) {
              SoulLocale.vi =>
                'Gói của bạn sẽ được cập nhật ngay lập tức với quyền lợi tương ứng.',
              SoulLocale.ko => '구독 플랜이 즉시 변경되며 해당 혜택이 적용됩니다.',
              SoulLocale.ja => 'プランは即座に更新され、対応する特典が有効になります。',
              SoulLocale.fr =>
                'Votre abonnement sera mis à jour immédiatement.',
              SoulLocale.zh => '你的会员计划将立即更新并生效相应权益。',
              SoulLocale.en => 'Your subscription will be updated immediately.',
            });

    final confirmLabel =
        isStartingNew
            ? (newPlanId == 'lifetime'
                ? (switch (locale) {
                  SoulLocale.vi => 'Mua ngay',
                  SoulLocale.ko => '지금 구매',
                  SoulLocale.ja => '今すぐ購入',
                  SoulLocale.fr => 'Acheter',
                  SoulLocale.zh => '立即购买',
                  SoulLocale.en => 'Purchase',
                })
                : (switch (locale) {
                  SoulLocale.vi => 'Bắt đầu dùng thử',
                  SoulLocale.ko => '체험 시작',
                  SoulLocale.ja => '体験を開始',
                  SoulLocale.fr => 'Démarrer l’essai',
                  SoulLocale.zh => '开启试用',
                  SoulLocale.en => 'Start Trial',
                }))
            : (switch (locale) {
              SoulLocale.vi => 'Chuyển gói',
              SoulLocale.ko => '플랜 변경',
              SoulLocale.ja => 'プランを変更',
              SoulLocale.fr => 'Changer de forfait',
              SoulLocale.zh => '确认切换',
              SoulLocale.en => 'Switch Plan',
            });

    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
    );

    if (confirmed) {
      if (isStartingNew) {
        if (newPlanId == 'lifetime') {
          await ref
              .read(paymentControllerProvider.notifier)
              .purchase(newPlanId);
        } else {
          await ref
              .read(paymentControllerProvider.notifier)
              .startTrial(newPlanId);
        }
      } else {
        await ref
            .read(paymentControllerProvider.notifier)
            .switchPlan(newPlanId);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isStartingNew
                  ? (newPlanId == 'lifetime'
                      ? (switch (locale) {
                        SoulLocale.vi => 'Đã mở khóa Gói Trọn Đời thành công!',
                        SoulLocale.ko => '평생 소장 플랜이 성공적으로 잠금 해제되었습니다!',
                        SoulLocale.ja => 'ライフタイムプランをアンロックしました！',
                        SoulLocale.fr => 'Accès à vie débloqué avec succès !',
                        SoulLocale.zh => '已成功开通终身会员！',
                        SoulLocale.en =>
                          'Lifetime access successfully unlocked!',
                      })
                      : (switch (locale) {
                        SoulLocale.vi =>
                          'Đã kích hoạt 7 ngày dùng thử miễn phí thành công!',
                        SoulLocale.ko => '7일 무료 체험이 성공적으로 시작되었습니다!',
                        SoulLocale.ja => '7日間の無料体験を開始しました！',
                        SoulLocale.fr =>
                          'Essai gratuit de 7 jours activé avec succès !',
                        SoulLocale.zh => '7天免费试用已成功开启！',
                        SoulLocale.en =>
                          '7-day free trial successfully started!',
                      }))
                  : (switch (locale) {
                    SoulLocale.vi => 'Đã chuyển sang $planName thành công!',
                    SoulLocale.ko => '$planName(으)로 성공적으로 변경되었습니다!',
                    SoulLocale.ja => '$planName に正常に変更されました！',
                    SoulLocale.fr => 'Passage à $planName réussi !',
                    SoulLocale.zh => '已成功更换至 $planName！',
                    SoulLocale.en => 'Successfully switched to $planName!',
                  }),
            ),
          ),
        );
      }
    }
  }
}

class _PlanSwitchTile extends StatelessWidget {
  const _PlanSwitchTile({
    required this.title,
    required this.price,
    required this.onSelect,
    required this.locale,
    this.badge,
  });

  final String title;
  final String price;
  final String? badge;
  final VoidCallback onSelect;
  final SoulLocale locale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SoulSpace.xs),
      child: SoulCard(
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.md,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: SoulColors.plum,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: SoulColors.plum,
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: SoulColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: SoulColors.plum),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: onSelect,
              child: Text(
                switch (locale) {
                  SoulLocale.vi => 'Chọn',
                  SoulLocale.ko => '선택',
                  SoulLocale.ja => '選択',
                  SoulLocale.fr => 'Choisir',
                  SoulLocale.zh => '选择',
                  SoulLocale.en => 'Select',
                },
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: SoulColors.plum,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
