import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../auth/auth_controller.dart';
import 'payment_controller.dart';
import 'subscription_state.dart';

/// Full-screen hard paywall gate shown when the user has no active subscription
/// (e.g. trial ended, cancelled and expired, or unsubscribed).
class PaywallGateScreen extends ConsumerStatefulWidget {
  const PaywallGateScreen({super.key});

  @override
  ConsumerState<PaywallGateScreen> createState() => _PaywallGateScreenState();
}

class _PaywallGateScreenState extends ConsumerState<PaywallGateScreen> {
  String _selectedPlan = 'yearly';
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);
    try {
      if (_selectedPlan == 'lifetime') {
        await ref
            .read(paymentControllerProvider.notifier)
            .purchase(_selectedPlan);
      } else {
        await ref
            .read(paymentControllerProvider.notifier)
            .startTrial(_selectedPlan);
      }
      if (mounted) {
        context.go('/app/today');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    try {
      final success =
          await ref.read(paymentControllerProvider.notifier).restorePurchases();
      if (mounted) {
        final locale = ref.read(appStateProvider).locale ?? SoulLocale.vi;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? (switch (locale) {
                    SoulLocale.vi => 'Đã khôi phục thành công gói mua của bạn!',
                    SoulLocale.ko => '구매 내역이 성공적으로 복원되었습니다!',
                    SoulLocale.ja => '購入内容を正常に復元しました！',
                    SoulLocale.fr =>
                      'Vos achats ont été restaurés avec succès !',
                    SoulLocale.zh => '已成功恢复你的购买！',
                    SoulLocale.en => 'Purchases successfully restored!',
                  })
                  : (switch (locale) {
                    SoulLocale.vi => 'Không tìm thấy gói mua nào trước đó.',
                    SoulLocale.ko => '이전 구매 내역을 찾을 수 없습니다.',
                    SoulLocale.ja => '過去の購入履歴が見つかりませんでした。',
                    SoulLocale.fr => 'Aucun achat précédent trouvé.',
                    SoulLocale.zh => '未找到以往的购买记录。',
                    SoulLocale.en => 'No previous purchase found.',
                  }),
            ),
          ),
        );
        if (success) {
          context.go('/app/today');
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignOut(SoulLocale locale) async {
    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: switch (locale) {
        SoulLocale.vi => 'Đăng xuất khỏi Soul?',
        SoulLocale.ko => 'Soul에서 로그아웃하시겠습니까?',
        SoulLocale.ja => 'Soulからログアウトしますか？',
        SoulLocale.fr => 'Se déconnecter de Soul ?',
        SoulLocale.zh => '退出 Soul 账号？',
        SoulLocale.en => 'Sign out of Soul?',
      },
      message: switch (locale) {
        SoulLocale.vi => 'Bạn có thể đăng nhập tài khoản khác để tiếp tục.',
        SoulLocale.ko => '다른 계정으로 로그인하여 계속할 수 있습니다.',
        SoulLocale.ja => '別のアカウントでログインして続行できます。',
        SoulLocale.fr =>
          'Vous pouvez vous connecter avec un autre compte pour continuer.',
        SoulLocale.zh => '你可以登录其他账号继续使用。',
        SoulLocale.en => 'You can sign in with another account to continue.',
      },
      confirmLabel: switch (locale) {
        SoulLocale.vi => 'Đăng xuất',
        SoulLocale.ko => '로그아웃',
        SoulLocale.ja => 'ログアウト',
        SoulLocale.fr => 'Se déconnecter',
        SoulLocale.zh => '退出登录',
        SoulLocale.en => 'Sign Out',
      },
    );
    if (!confirmed) return;
    await ref.read(audioPlaybackProvider).stop();
    await ref.read(authControllerProvider.notifier).signOut();
    await ref.read(appStateProvider).resetAll();
    if (mounted) {
      context.go('/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final locale = state.locale ?? SoulLocale.vi;
    final textTheme = Theme.of(context).textTheme;

    final headline = switch (locale) {
      SoulLocale.vi => 'Tiếp tục nuôi dưỡng tâm hồn cùng Soul',
      SoulLocale.ko => 'Soul과 함께 마음을 계속 보살펴보세요',
      SoulLocale.ja => 'Soulと共に、心を育み続けましょう',
      SoulLocale.fr => 'Continuez à nourrir votre âme avec Soul',
      SoulLocale.zh => '与 Soul 一起，继续滋养你的心灵',
      SoulLocale.en => 'Continue Nurturing Your Soul with Soul',
    };

    final subtitle = switch (locale) {
      SoulLocale.vi =>
        'Gói đăng ký của bạn đã kết thúc. Chọn một gói bên dưới để tiếp tục duy trì không gian bình yên, âm thanh chữa lành & hành trình chuyển hóa mỗi ngày.',
      SoulLocale.ko =>
        '구독이 만료되었습니다. 아래에서 플랜을 선택하여 평온한 안식처, 치유 사운드 및 매일의 마음챙김 여정을 계속 이어가세요.',
      SoulLocale.ja =>
        'サブスクリプションの有効期限が切れました。プランを選択して、穏やかな癒やし空間、周波数サウンド、毎日の旅を続けましょう。',
      SoulLocale.fr =>
        'Votre abonnement a pris fin. Choisissez un forfait ci-dessous pour préserver vos sanctuaires de paix, vos audios de guérison et votre voyage intérieur.',
      SoulLocale.zh => '你的会员计划已到期。选择下方计划，继续留住宁静的心灵空间、疗愈音频与每日蜕变旅程。',
      SoulLocale.en =>
        'Your subscription has ended. Choose a plan below to keep your peaceful sanctuaries, healing audio & daily transformation journey.',
    };

    final benefits = switch (locale) {
      SoulLocale.vi => const [
        '28 không gian Comfort Zone & âm thanh tần số chữa lành',
        'Bảng tầm nhìn (Vision Board) & rút thẻ thông điệp mỗi ngày',
        'Hành trình 28 ngày chuyển hóa tâm thức & nhật ký biết ơn riêng tư',
      ],
      SoulLocale.ko => const [
        '28개 Comfort Zone 안식처 & 주파수 치유 사운드 무제한',
        '무제한 비전 보드 및 데일리 소울 카드',
        '28일간의 마음챙김 감사 저널 여정',
      ],
      SoulLocale.ja => const [
        '全28のComfort Zone癒やし空間＆ヒーリング周波数',
        '無制限のビジョンボード＆毎日のソウルカード',
        '28日間のマインドフルネス感謝ジャーナル',
      ],
      SoulLocale.fr => const [
        'Tous les 28 espaces Comfort Zone et fréquences de guérison',
        'Vision Board illimité et tirage de cartes Soul',
        'Voyage de 28 jours de gratitude et journal intérieur',
      ],
      SoulLocale.zh => const [
        '全部 28 个 Comfort Zone 空间与疗愈频率音频',
        '无限愿景板与每日心灵指引卡',
        '28 天正念感恩旅程与深度内心日记',
      ],
      SoulLocale.en => const [
        'All 28 Comfort Zone sanctuaries & healing frequency audio',
        'Unlimited Vision Board & daily Soul cards',
        '28-day mindfulness gratitude transformation journey',
      ],
    };

    final plans = [
      (
        id: 'yearly',
        title: SubscriptionState.formatPlanTitle('yearly', locale),
        price: SubscriptionState.formatPlanPrice('yearly', locale),
        subtitle: switch (locale) {
          SoulLocale.vi => 'Đồng hành bền bỉ 365 ngày · Tiết kiệm 17%',
          SoulLocale.ko => '365일 꾸준한 여정 · 17% 할인',
          SoulLocale.ja => '365日寄り添う旅 · 17%お得',
          SoulLocale.fr => '365 jours de fidélité · Économisez 17%',
          SoulLocale.zh => '365天坚定陪伴 · 节省 17%',
          SoulLocale.en => '365 days devotion · Save 17%',
        },
        badge: switch (locale) {
          SoulLocale.vi => 'KHUYÊN DÙNG',
          SoulLocale.ko => '추천 플랜',
          SoulLocale.ja => 'おすすめ',
          SoulLocale.fr => 'RECOMMANDÉ',
          SoulLocale.zh => '首选推荐',
          SoulLocale.en => 'RECOMMENDED',
        },
      ),
      (
        id: 'monthly',
        title: SubscriptionState.formatPlanTitle('monthly', locale),
        price: SubscriptionState.formatPlanPrice('monthly', locale),
        subtitle: switch (locale) {
          SoulLocale.vi => 'Linh hoạt từng tháng, tự do hủy bất cứ lúc nào',
          SoulLocale.ko => '매달 유연하게, 언제든 자유롭게 취소',
          SoulLocale.ja => '月々の更新、いつでも解約可能',
          SoulLocale.fr => 'Mensuel flexible, résiliation libre à tout moment',
          SoulLocale.zh => '按月灵活订阅，随时可自由取消',
          SoulLocale.en => 'Flexible monthly, cancel anytime',
        },
        badge: null as String?,
      ),
      (
        id: 'lifetime',
        title: SubscriptionState.formatPlanTitle('lifetime', locale),
        price: SubscriptionState.formatPlanPrice('lifetime', locale),
        subtitle: switch (locale) {
          SoulLocale.vi => 'Thanh toán 1 lần duy nhất, sở hữu trọn đời',
          SoulLocale.ko => '단 한 번의 결제로 평생 영구 소장',
          SoulLocale.ja => '1度のお支払いで永久アクセス',
          SoulLocale.fr => 'Paiement unique, vôtre pour toujours',
          SoulLocale.zh => '一次性买断，永久畅享全部功能',
          SoulLocale.en => 'One-time payment, yours forever',
        },
        badge: switch (locale) {
          SoulLocale.vi => 'GIÁ TRỊ NHẤT',
          SoulLocale.ko => '최고의 가치',
          SoulLocale.ja => 'ベストバリュー',
          SoulLocale.fr => 'MEILLEURE VALEUR',
          SoulLocale.zh => '终身超值',
          SoulLocale.en => 'BEST VALUE',
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SoulSpace.lg,
            vertical: SoulSpace.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Action Bar: Language Selector & Sign Out
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: SoulColors.softFill,
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                      border: Border.all(color: SoulColors.line),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SoulLocale>(
                        value: locale,
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: SoulColors.plum,
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: SoulColors.plum,
                          fontWeight: FontWeight.w600,
                        ),
                        items: [
                          for (final item in SoulLocale.values)
                            DropdownMenuItem(
                              value: item,
                              child: Text(switch (item) {
                                SoulLocale.vi => 'Tiếng Việt',
                                SoulLocale.en => 'English',
                                _ => item.endonym,
                              }),
                            ),
                        ],
                        onChanged: (newLoc) {
                          if (newLoc != null) {
                            ref.read(appStateProvider).selectLocale(newLoc);
                          }
                        },
                      ),
                    ),
                  ),

                  // Sign Out button
                  TextButton.icon(
                    onPressed: () => _handleSignOut(locale),
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 16,
                      color: SoulColors.muted,
                    ),
                    label: Text(
                      switch (locale) {
                        SoulLocale.vi => 'Đăng xuất',
                        SoulLocale.ko => '로그아웃',
                        SoulLocale.ja => 'ログアウト',
                        SoulLocale.fr => 'Déconnexion',
                        SoulLocale.zh => '退出登录',
                        SoulLocale.en => 'Sign Out',
                      },
                      style: textTheme.bodySmall?.copyWith(
                        color: SoulColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SoulSpace.lg),

              // Soul Emblem & Headline
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFAE4E6), Color(0xFFE9DFF3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SoulColors.plum.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: SoulColors.plum,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SoulSpace.md),

              // Main Headline (requested by user)
              Text(
                headline,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: SoulColors.plum,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: SoulSpace.xs),

              // Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: SoulColors.softInk,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: SoulSpace.lg),

              // Benefits Box
              Container(
                padding: const EdgeInsets.all(SoulSpace.md),
                decoration: BoxDecoration(
                  color: SoulColors.softFill.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(SoulRadius.card),
                  border: Border.all(color: SoulColors.line),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < benefits.length; i++) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: SoulColors.plum,
                            ),
                          ),
                          const SizedBox(width: SoulSpace.xs),
                          Expanded(
                            child: Text(
                              benefits[i],
                              style: textTheme.bodySmall?.copyWith(
                                color: SoulColors.plum,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (i < benefits.length - 1)
                        const SizedBox(height: SoulSpace.xs),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: SoulSpace.lg),

              // Plan Options
              for (final plan in plans) ...[
                _PaywallGatePlanCard(
                  id: plan.id,
                  title: plan.title,
                  price: plan.price,
                  subtitle: plan.subtitle,
                  badge: plan.badge,
                  isSelected: _selectedPlan == plan.id,
                  onTap: () => setState(() => _selectedPlan = plan.id),
                ),
                const SizedBox(height: SoulSpace.sm),
              ],
              const SizedBox(height: SoulSpace.md),

              // Primary CTA Button
              SoulButton(
                label:
                    _isLoading
                        ? (switch (locale) {
                          SoulLocale.vi => 'Đang xử lý...',
                          SoulLocale.ko => '처리 중...',
                          SoulLocale.ja => '処理中...',
                          SoulLocale.fr => 'Traitement...',
                          SoulLocale.zh => '处理中...',
                          SoulLocale.en => 'Processing...',
                        })
                        : (switch (locale) {
                          SoulLocale.vi => 'Tiếp tục hành trình',
                          SoulLocale.ko => '여정 계속하기',
                          SoulLocale.ja => '旅を続ける',
                          SoulLocale.fr => 'Poursuivre le voyage',
                          SoulLocale.zh => '继续旅程',
                          SoulLocale.en => 'Continue Journey',
                        }),
                onPressed: _isLoading ? null : _handleContinue,
              ),
              const SizedBox(height: SoulSpace.md),

              // Restore Purchases Link
              Center(
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _handleRestore,
                  icon: const Icon(
                    Icons.restore_rounded,
                    size: 16,
                    color: SoulColors.plum,
                  ),
                  label: Text(
                    switch (locale) {
                      SoulLocale.vi => 'Khôi phục gói mua trên thiết bị này',
                      SoulLocale.ko => '이 기기에서 구매 내역 복원',
                      SoulLocale.ja => 'この端末で購入内容を復元',
                      SoulLocale.fr => 'Restaurer les achats sur cet appareil',
                      SoulLocale.zh => '在此设备上恢复购买',
                      SoulLocale.en => 'Restore Purchases on this device',
                    },
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SoulColors.plum,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SoulSpace.xs),

              // Store terms notice
              Text(
                switch (locale) {
                  SoulLocale.vi =>
                    'Thanh toán được bảo mật và quản lý tự động bởi Apple App Store / Google Play. Hủy bất kỳ lúc nào trong phần cài đặt của Store.',
                  SoulLocale.ko =>
                    '결제는 Apple App Store 및 Google Play를 통해 안전하게 처리됩니다. Store 설정에서 언제든지 취소할 수 있습니다.',
                  SoulLocale.ja =>
                    'お支払いは Apple App Store / Google Play により安全に管理されます。ストアの設定からいつでも解約可能です。',
                  SoulLocale.fr =>
                    'Paiements sécurisés par Apple App Store / Google Play. Résiliation possible à tout moment dans les réglages du Store.',
                  SoulLocale.zh =>
                    '所有付款均由 Apple App Store / Google Play 安全管理。你可随时在应用商店设置中取消。',
                  SoulLocale.en =>
                    'Payments securely managed by Apple App Store / Google Play. Cancel anytime in Store settings.',
                },
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: SoulColors.muted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaywallGatePlanCard extends StatelessWidget {
  const _PaywallGatePlanCard({
    required this.id,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final String id;
  final String title;
  final String price;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.md,
          vertical: SoulSpace.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9F0F6) : Colors.white,
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(
            color: isSelected ? SoulColors.plum : SoulColors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: SoulColors.plum.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Row(
          children: [
            // Custom Radio Indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? SoulColors.plum : Colors.transparent,
                border: Border.all(
                  color: isSelected ? SoulColors.plum : SoulColors.inputBorder,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: SoulSpace.sm),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color:
                              isSelected
                                  ? SoulColors.plum
                                  : const Color(0xFF2C242A),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? SoulColors.plum
                                    : const Color(0xFFE5C8A8),
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF7A4B1A),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isSelected ? SoulColors.plum : SoulColors.muted,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SoulSpace.xs),

            // Price
            Text(
              price,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: isSelected ? SoulColors.plum : const Color(0xFF2C242A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
