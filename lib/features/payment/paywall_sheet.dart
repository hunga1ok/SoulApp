import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../auth/auth_bottom_sheet.dart';
import '../auth/auth_controller.dart';
import 'payment_controller.dart';
import 'subscription_state.dart';

/// Shows reusable Paywall Modal anywhere in the app (e.g. from Profile).
Future<void> showPaywallModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _PaywallSheet(),
  );
}

/// Shows a warm celebration sheet after a successful purchase.
Future<void> showPurchaseSuccessSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => const _PurchaseSuccessSheet(),
  );
}

class _PaywallSheet extends ConsumerStatefulWidget {
  const _PaywallSheet();

  @override
  ConsumerState<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<_PaywallSheet> {
  String _selectedPlan = 'yearly';
  bool _isLoading = false;

  Future<void> _handlePurchase() async {
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
        Navigator.pop(context);
        showPurchaseSuccessSheet(context);
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
        if (success) Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final textTheme = Theme.of(context).textTheme;

    final plans = [
      (
        id: 'monthly',
        title: switch (locale) {
          SoulLocale.vi => 'Gói Tháng',
          SoulLocale.ko => '월간 플랜',
          SoulLocale.ja => '月額プラン',
          SoulLocale.fr => 'Forfait Mensuel',
          SoulLocale.zh => '月度计划',
          SoulLocale.en => 'Monthly Plan',
        },
        price: SubscriptionState.formatPlanPrice('monthly', locale),
        subtitle: switch (locale) {
          SoulLocale.vi => 'Khởi đầu nhẹ nhàng, rèn luyện thói quen mỗi ngày',
          SoulLocale.ko => '가볍게 시작하며 매일 감사의 습관을 기르세요',
          SoulLocale.ja => '穏やかに始めて、毎日の感謝の習慣を育む',
          SoulLocale.fr =>
            'Un départ en douceur pour ancrer votre habitude quotidienne',
          SoulLocale.zh => '温和开启，养成每日感恩与正念习惯',
          SoulLocale.en => 'Gentle start, build your daily gratitude habit',
        },
        badge: null as String?,
      ),
      (
        id: 'yearly',
        title: switch (locale) {
          SoulLocale.vi => 'Gói Năm',
          SoulLocale.ko => '연간 플랜',
          SoulLocale.ja => '年額プラン',
          SoulLocale.fr => 'Forfait Annuel',
          SoulLocale.zh => '年度计划',
          SoulLocale.en => 'Yearly Plan',
        },
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
          SoulLocale.vi => 'PHỔ BIẾN NHẤT',
          SoulLocale.ko => '인기 플랜',
          SoulLocale.ja => '一番人気',
          SoulLocale.fr => 'LE PLUS POPULAIRE',
          SoulLocale.zh => '最受欢迎',
          SoulLocale.en => 'MOST POPULAR',
        },
      ),
      (
        id: 'lifetime',
        title: switch (locale) {
          SoulLocale.vi => 'Gói Trọn Đời',
          SoulLocale.ko => '평생 소장 플랜',
          SoulLocale.ja => 'ライフタイムプラン',
          SoulLocale.fr => 'Accès à Vie',
          SoulLocale.zh => '终身计划',
          SoulLocale.en => 'Lifetime Plan',
        },
        price: SubscriptionState.formatPlanPrice('lifetime', locale),
        subtitle: switch (locale) {
          SoulLocale.vi => 'Thanh toán 1 lần, sở hữu mãi mãi không gian an yên',
          SoulLocale.ko => '한 번 결제로 평생 소장하는 안식처',
          SoulLocale.ja => '1度のお支払いで永遠の安らぎへ',
          SoulLocale.fr => 'Un seul paiement, votre sanctuaire pour toujours',
          SoulLocale.zh => '一次付费，永久拥有心灵安宁空间',
          SoulLocale.en => 'One-time payment, yours forever',
        },
        badge: switch (locale) {
          SoulLocale.vi => 'GIÁ TRỊ NHẤT',
          SoulLocale.ko => '최고의 가치',
          SoulLocale.ja => 'ベストバリュー',
          SoulLocale.fr => 'MEILLEURE VALEUR',
          SoulLocale.zh => '超值首选',
          SoulLocale.en => 'BEST VALUE',
        },
      ),
    ];

    final benefits = switch (locale) {
      SoulLocale.vi => const [
        'Trọn bộ 28 không gian Comfort Zone & âm thanh tần số chữa lành',
        'Bảng tầm nhìn (Vision Board) không giới hạn & rút thẻ thông điệp',
        'Hành trình 28 ngày chuyển hóa tâm thức & nhật ký biết ơn',
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

    return Container(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4.5,
                decoration: BoxDecoration(
                  color: SoulColors.line,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: SoulSpace.md),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SoulSpace.xs,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: SoulColors.lilac,
                    borderRadius: BorderRadius.circular(SoulRadius.button),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 13,
                        color: SoulColors.plum,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SOUL PREMIUM',
                        style: textTheme.labelSmall?.copyWith(
                          color: SoulColors.plum,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: SoulColors.muted,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: SoulSpace.xs),

            Text(
              switch (locale) {
                SoulLocale.vi => 'Nâng cấp Soul Premium',
                SoulLocale.ko => 'Soul 프리미엄으로 업그레이드',
                SoulLocale.ja => 'Soul プレミアムにアップグレード',
                SoulLocale.fr => 'Passer à Soul Premium',
                SoulLocale.zh => '升级到 Soul 高级版',
                SoulLocale.en => 'Upgrade to Soul Premium',
              },
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: SoulColors.plum,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              switch (locale) {
                SoulLocale.vi =>
                  'Mở khóa trọn vẹn không gian an yên và nuôi dưỡng tâm hồn mỗi ngày.',
                SoulLocale.ko => '매일 마음을 어루만지는 평온한 안식처를 모두 누려보세요.',
                SoulLocale.ja => '毎日を心地よく過ごすためのすべての機能をお手元に。',
                SoulLocale.fr =>
                  'Débloquez l’intégralité de votre sanctuaire de paix.',
                SoulLocale.zh => '完全解锁属于你的宁静空间，每日滋养内心。',
                SoulLocale.en =>
                  'Unlock your complete sanctuary of peace and gentle reflection.',
              },
              style: textTheme.bodyMedium?.copyWith(
                color: SoulColors.softInk,
                height: 1.35,
              ),
            ),
            const SizedBox(height: SoulSpace.md),

            // Benefits Card
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SoulSpace.md,
                vertical: SoulSpace.sm,
              ),
              decoration: BoxDecoration(
                color: SoulColors.softFill,
                borderRadius: BorderRadius.circular(SoulRadius.card),
                border: Border.all(color: SoulColors.line),
              ),
              child: Column(
                children: [
                  for (final b in benefits)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 15,
                              color: SoulColors.plum,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              b,
                              style: textTheme.bodySmall?.copyWith(
                                color: SoulColors.plum,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: SoulSpace.md),

            // Plan Cards
            for (final plan in plans) ...[
              _PlanSelectionTile(
                title: plan.title,
                price: plan.price,
                subtitle: plan.subtitle,
                badge: plan.badge,
                selected: _selectedPlan == plan.id,
                onTap: () => setState(() => _selectedPlan = plan.id),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: SoulSpace.md),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(SoulSpace.md),
                  child: CircularProgressIndicator(color: SoulColors.plum),
                ),
              )
            else ...[
              SoulButton(
                label:
                    _selectedPlan == 'lifetime'
                        ? (switch (locale) {
                          SoulLocale.vi => 'Sở hữu trọn đời – \$50',
                          SoulLocale.ko => '평생 소장 – \$50',
                          SoulLocale.ja => '永久アクセス – \$50',
                          SoulLocale.fr => 'Accès à vie – 50 \$',
                          SoulLocale.zh => '终身买断 – \$50',
                          SoulLocale.en => 'Lifetime Access – \$50',
                        })
                        : (switch (locale) {
                          SoulLocale.vi => 'Bắt đầu 7 ngày miễn phí & Nâng cấp',
                          SoulLocale.ko => '7일 무료 체험 후 시작하기',
                          SoulLocale.ja => '7日間の無料体験で始める',
                          SoulLocale.fr =>
                            'Essai gratuit de 7 jours & Commencer',
                          SoulLocale.zh => '开启 7 天免费试用并升级',
                          SoulLocale.en => 'Start 7-Day Free Trial & Upgrade',
                        }),
                onPressed: _handlePurchase,
              ),
              const SizedBox(height: SoulSpace.sm),

              // Restore & Sign in links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _handleRestore,
                    child: Text(
                      switch (locale) {
                        SoulLocale.vi => 'Khôi phục gói mua',
                        SoulLocale.ko => '구매 내역 복원',
                        SoulLocale.ja => '購入を復元',
                        SoulLocale.fr => 'Restaurer les achats',
                        SoulLocale.zh => '恢复购买',
                        SoulLocale.en => 'Restore Purchases',
                      },
                      style: const TextStyle(
                        color: SoulColors.muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(' · ', style: TextStyle(color: SoulColors.line)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showAuthBottomSheet(context);
                    },
                    child: Text(
                      switch (locale) {
                        SoulLocale.vi => 'Đã có tài khoản? Đăng nhập',
                        SoulLocale.ko => '이미 계정이 있나요? 로그인',
                        SoulLocale.ja => 'アカウントをお持ちですか？ログイン',
                        SoulLocale.fr => 'Déjà un compte ? Connexion',
                        SoulLocale.zh => '已有账号？登录',
                        SoulLocale.en => 'Have an account? Sign in',
                      },
                      style: const TextStyle(
                        color: SoulColors.plum,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanSelectionTile extends StatelessWidget {
  const _PlanSelectionTile({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String price;
  final String subtitle;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.sm + 2,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? SoulColors.selectedFill : SoulColors.surface,
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(
            color: selected ? SoulColors.plum : SoulColors.line,
            width: selected ? 2.0 : 1.0,
          ),
          boxShadow: selected ? SoulShadows.card : const [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? SoulColors.plum : SoulColors.muted,
                size: 19,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: SoulColors.plum,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: SoulColors.plum,
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 9.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      Text(
                        price,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: SoulColors.plum,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: SoulColors.softInk,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseSuccessSheet extends ConsumerWidget {
  const _PurchaseSuccessSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;

    return Container(
      padding: const EdgeInsets.all(SoulSpace.xl),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF0D4), Color(0xFFFFD59E)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB74D).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFB86A2E),
              size: 36,
            ),
          ),
          const SizedBox(height: SoulSpace.md),
          Text(
            switch (locale) {
              SoulLocale.vi => 'Chào mừng đến với Soul Premium! 🌟',
              SoulLocale.ko => 'Soul 프리미엄 회원이 되신 것을 환영합니다! 🌟',
              SoulLocale.ja => 'Soul プレミアムへようこそ！🌟',
              SoulLocale.fr => 'Bienvenue dans Soul Premium ! 🌟',
              SoulLocale.zh => '欢迎成为 Soul 高级会员！🌟',
              SoulLocale.en => 'Welcome to Soul Premium! 🌟',
            },
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: SoulColors.plum,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            switch (locale) {
              SoulLocale.vi =>
                'Toàn bộ 28 không gian Comfort Zone, Bảng tầm nhìn không giới hạn và chuỗi thực hành biết ơn đã sẵn sàng cho bạn.',
              SoulLocale.ko => '28개의 안식처 공간과 무제한 비전 보드를 마음껏 이용하세요.',
              SoulLocale.ja => '28の癒やし空間と無制限のビジョンボードがご利用いただけます。',
              SoulLocale.fr =>
                'Tous les 28 espaces et le Vision Board illimité sont désormais disponibles.',
              SoulLocale.zh => '所有 28 个疗愈空间与无限愿景板已为你完全开启。',
              SoulLocale.en =>
                'All 28 sanctuaries, unlimited Vision Boards, and the full journey are unlocked.',
            },
            textAlign: TextAlign.center,
            style: const TextStyle(color: SoulColors.muted, height: 1.4),
          ),
          const SizedBox(height: SoulSpace.lg),

          if (user.isGuest) ...[
            Container(
              padding: const EdgeInsets.all(SoulSpace.md),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(SoulRadius.card),
                border: Border.all(color: const Color(0xFFFFE0B2)),
              ),
              child: Column(
                children: [
                  Text(
                    switch (locale) {
                      SoulLocale.vi =>
                        'Đồng bộ tài khoản để bảo lưu gói mua trọn đời khi đổi máy:',
                      SoulLocale.ko => '기기 변경 시에도 구독 혜택을 유지하려면 계정을 연동하세요:',
                      SoulLocale.ja => 'デバイス変更時にも購入内容を保護するために連携してください：',
                      SoulLocale.fr =>
                        'Liez votre compte pour conserver votre forfait sur un nouvel appareil :',
                      SoulLocale.zh => '关联账号以便在更换设备时保留你的会员权益：',
                      SoulLocale.en =>
                        'Link your account to keep your subscription synced across devices:',
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: SoulColors.plum,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SoulButton(
                    label: switch (locale) {
                      SoulLocale.vi => 'Liên kết với Google / Apple ngay',
                      SoulLocale.ko => 'Google / Apple 계정 연동하기',
                      SoulLocale.ja => 'Google / Apple と連携',
                      SoulLocale.fr => 'Lier avec Google / Apple',
                      SoulLocale.zh => '立即关联 Google / Apple',
                      SoulLocale.en => 'Link with Google / Apple now',
                    },
                    onPressed: () {
                      Navigator.pop(context);
                      showAuthBottomSheet(context, isLinking: true);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SoulSpace.md),
          ],

          SoulButton(
            label: switch (locale) {
              SoulLocale.vi => 'Bắt đầu khám phá ngay',
              SoulLocale.ko => '지금 시작하기',
              SoulLocale.ja => '今すぐ始める',
              SoulLocale.fr => 'Commencer à explorer',
              SoulLocale.zh => '立即开启探索',
              SoulLocale.en => 'Start Exploring Now',
            },
            variant:
                user.isGuest
                    ? SoulButtonVariant.secondary
                    : SoulButtonVariant.primary,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
