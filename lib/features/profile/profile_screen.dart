import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/device_services.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_bottom_sheet.dart';
import '../auth/auth_controller.dart';
import '../onboarding/onboarding_screens.dart';
import '../payment/billing_subscription_screen.dart';
import '../payment/payment_controller.dart';
import '../payment/paywall_sheet.dart';
import 'home_widget_screen.dart';
import 'reminder_settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final user = ref.watch(authControllerProvider);
    final sub = ref.watch(paymentControllerProvider);
    final preferredName = state.preferredName ?? user.displayName;
    final soundEnabled = state.soundEnabled;
    final locale = state.locale ?? SoulLocale.vi;

    return Scaffold(
      appBar: SoulAppBar(title: l10n.profile, onBack: () => context.pop()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.lg,
          vertical: SoulSpace.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. User Avatar & Account Info Card
            Container(
              padding: const EdgeInsets.all(SoulSpace.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SoulRadius.card),
                border: Border.all(color: SoulColors.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: SoulColors.lilac,
                    foregroundColor: SoulColors.plum,
                    child: Text(
                      (preferredName?.isNotEmpty == true ? preferredName! : 'S')
                          .characters
                          .first
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: SoulSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preferredName?.isNotEmpty == true
                              ? preferredName!
                              : (switch (locale) {
                                SoulLocale.vi => 'Người bạn của Soul',
                                SoulLocale.ko => 'Soul의 친구',
                                SoulLocale.ja => 'Soulの友',
                                SoulLocale.fr => "Ami de Soul",
                                SoulLocale.zh => 'Soul 之友',
                                SoulLocale.en => 'Soul Member',
                              }),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: SoulColors.plum,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.isGuest
                              ? (switch (locale) {
                                SoulLocale.vi =>
                                  'Tài khoản Khách · Chưa đồng bộ',
                                SoulLocale.ko => '게스트 계정 · 로컬 전용',
                                SoulLocale.ja => 'ゲストアカウント · ローカルのみ',
                                SoulLocale.fr =>
                                  'Compte invité · Stockage local',
                                SoulLocale.zh => '访客账号 · 仅限本地存储',
                                SoulLocale.en => 'Guest Account · Local only',
                              })
                              : (user.email ?? user.providerTitle),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: SoulColors.muted),
                        ),
                        if (user.isGuest) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            onTap:
                                () => showAuthBottomSheet(
                                  context,
                                  isLinking: true,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3E5F5),
                                borderRadius: BorderRadius.circular(
                                  SoulRadius.button,
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFFCE93D8,
                                  ).withValues(alpha: 0.6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 13,
                                    color: Color(0xFF7B1FA2),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      switch (locale) {
                                        SoulLocale.vi => 'Liên kết tài khoản',
                                        SoulLocale.ko => '계정 연동',
                                        SoulLocale.ja => 'アカウント連携',
                                        SoulLocale.fr => 'Lier le compte',
                                        SoulLocale.zh => '关联账号',
                                        SoulLocale.en => 'Link Account',
                                      },
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF7B1FA2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SoulSpace.md),

            if (sub.isPremium)
              InkWell(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BillingSubscriptionScreen(),
                      ),
                    ),
                borderRadius: BorderRadius.circular(SoulRadius.card),
                child: Container(
                  padding: const EdgeInsets.all(SoulSpace.md),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF9F2), Color(0xFFFDF1E6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(SoulRadius.card),
                    border: Border.all(
                      color: const Color(0xFFE2C4A2).withValues(alpha: 0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD99C4B).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE0B2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Color(0xFFB86A2E),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: SoulSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Soul Premium (${sub.localizedPlanTitle(locale)})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SoulColors.plum,
                                fontSize: 14.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sub.isLifetime
                                  ? (switch (locale) {
                                    SoulLocale.vi =>
                                      'Sở hữu vĩnh viễn · Không giới hạn',
                                    SoulLocale.ko => '평생 소장 · 무제한 이용',
                                    SoulLocale.ja => '永久アクセス · 無制限',
                                    SoulLocale.fr => 'Accès à vie · Illimité',
                                    SoulLocale.zh => '终身会员 · 无限畅享',
                                    SoulLocale.en =>
                                      'Lifetime Access · Unlimited',
                                  })
                                  : (sub.isTrial
                                      ? (switch (locale) {
                                        SoulLocale.vi =>
                                          'Dùng thử 7 ngày · Còn ${sub.trialDaysRemaining} ngày',
                                        SoulLocale.ko =>
                                          '7일 무료 체험 · ${sub.trialDaysRemaining}일 남음',
                                        SoulLocale.ja =>
                                          '7日間無料体験 · 残り${sub.trialDaysRemaining}日',
                                        SoulLocale.fr =>
                                          'Essai de 7 jours · ${sub.trialDaysRemaining} jours restants',
                                        SoulLocale.zh =>
                                          '7天免费试用 · 剩余 ${sub.trialDaysRemaining} 天',
                                        SoulLocale.en =>
                                          '7-Day Trial · ${sub.trialDaysRemaining} days left',
                                      })
                                      : (sub.isAutoRenew
                                          ? (switch (locale) {
                                            SoulLocale.vi =>
                                              'Đang hoạt động · Tự động gia hạn',
                                            SoulLocale.ko => '이용 중 · 자동 갱신',
                                            SoulLocale.ja => '有効 · 自動更新',
                                            SoulLocale.fr =>
                                              'Actif · Renouvellement auto',
                                            SoulLocale.zh => '生效中 · 自动续费',
                                            SoulLocale.en =>
                                              'Active · Auto-renews',
                                          })
                                          : (switch (locale) {
                                            SoulLocale.vi =>
                                              'Đã hủy gia hạn tự động',
                                            SoulLocale.ko => '자동 갱신 취소됨',
                                            SoulLocale.ja => '自動更新解除済み',
                                            SoulLocale.fr =>
                                              'Renouvellement auto annulé',
                                            SoulLocale.zh => '已取消自动续费',
                                            SoulLocale.en =>
                                              'Auto-renewal cancelled',
                                          }))),
                              style: const TextStyle(
                                color: Color(0xFF8D6E63),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFB86A2E),
                      ),
                    ],
                  ),
                ),
              )
            else
              InkWell(
                onTap: () => showPaywallModal(context),
                borderRadius: BorderRadius.circular(SoulRadius.card),
                child: Container(
                  padding: const EdgeInsets.all(SoulSpace.md),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBF4FD), Color(0xFFF5E8F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(SoulRadius.card),
                    border: Border.all(
                      color: const Color(0xFFD8B4D6).withValues(alpha: 0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C4D88).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1BEE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: SoulColors.plum,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: SoulSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              switch (locale) {
                                SoulLocale.vi => 'Nâng cấp Soul Premium',
                                _ => 'Upgrade to Soul Premium',
                              },
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SoulColors.plum,
                                fontSize: 14.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              switch (locale) {
                                SoulLocale.vi =>
                                  'Mở khóa 28 không gian, Vision Board & Tần số',
                                _ =>
                                  'Unlock all 28 spaces, Vision Board & Frequencies',
                              },
                              style: const TextStyle(
                                color: SoulColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: SoulColors.plum,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: SoulSpace.lg),

            // 3. App Settings Rows
            _SettingRow(
              icon: Icons.edit_outlined,
              label: l10n.editName,
              onTap: () => context.push('/profile/name'),
            ),
            _SettingRow(
              icon:
                  soundEnabled
                      ? Icons.volume_up_outlined
                      : Icons.volume_off_outlined,
              label: soundEnabled ? l10n.soundOn : l10n.soundOff,
              onTap: () async {
                final newSound = !soundEnabled;
                await state.setSoundEnabled(newSound);
                if (!newSound) {
                  await ref.read(audioPlaybackProvider).stop();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SoulSpace.sm),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, color: SoulColors.plum),
                  const SizedBox(width: SoulSpace.md),
                  Expanded(
                    child: Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(width: SoulSpace.sm),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SoulLocale>(
                            value: state.locale ?? SoulLocale.vi,
                            isDense: true,
                            alignment: AlignmentDirectional.centerEnd,
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: SoulColors.plum,
                              fontWeight: FontWeight.w600,
                            ),
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: SoulColors.plum,
                                size: 20,
                              ),
                            ),
                            items: [
                              for (final itemLocale in SoulLocale.values)
                                DropdownMenuItem(
                                  value: itemLocale,
                                  child: Text(switch (itemLocale) {
                                    SoulLocale.vi => l10n.vietnameseLanguage,
                                    SoulLocale.en => l10n.englishLanguage,
                                    _ => itemLocale.endonym,
                                  }),
                                ),
                            ],
                            onChanged: (newLocale) async {
                              if (newLocale == null) return;
                              await ref.read(audioPlaybackProvider).stop();
                              await ref
                                  .read(appStateProvider)
                                  .selectLocale(newLocale);
                              final choices =
                                  await ref
                                      .read(reminderRepositoryProvider)
                                      .load();
                              await ref
                                  .read(notificationPermissionsProvider)
                                  .scheduleDailyReminders(
                                    choices: choices,
                                    locale: newLocale,
                                    preferredName:
                                        ref
                                            .read(appStateProvider)
                                            .preferredName,
                                  );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _SettingRow(
              icon: Icons.widgets_outlined,
              label: l10n.homeWidgetTitle,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeWidgetScreen()),
                  ),
            ),
            _SettingRow(
              icon: Icons.notifications_none_rounded,
              label: l10n.reminderSettingsTitle,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReminderSettingsScreen(),
                    ),
                  ),
            ),
            _SettingRow(
              icon: Icons.auto_awesome_outlined,
              label: l10n.revisitOnboarding,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const WelcomeIntroScreen(isRevisiting: true),
                    ),
                  ),
            ),

            // Subscription & Billing
            _SettingRow(
              icon: Icons.credit_card_outlined,
              label: switch (locale) {
                SoulLocale.vi => 'Gói đăng ký & Thanh toán',
                SoulLocale.ko => '구독 및 결제 관리',
                SoulLocale.ja => 'サブスクリプションと支払い',
                SoulLocale.fr => 'Abonnement et facturation',
                SoulLocale.zh => '订阅与账单管理',
                SoulLocale.en => 'Subscription & Billing',
              },
              trailing: Text(
                sub.localizedPlanTitle(locale),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: SoulColors.plum,
                ),
              ),
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BillingSubscriptionScreen(),
                    ),
                  ),
            ),

            // Sign In (if guest) and Sign Out
            if (user.isGuest)
              _SettingRow(
                icon: Icons.login_rounded,
                label: switch (locale) {
                  SoulLocale.vi => 'Đăng nhập tài khoản',
                  SoulLocale.ko => '계정 로그인',
                  SoulLocale.ja => 'ログイン',
                  SoulLocale.fr => 'Connexion au compte',
                  SoulLocale.zh => '登录账号',
                  SoulLocale.en => 'Sign In',
                },
                onTap: () => showAuthBottomSheet(context),
              ),
            _SettingRow(
              icon: Icons.logout_rounded,
              label: l10n.signOut,
              onTap: () => _confirmSignOut(context, ref, l10n),
            ),

            // Delete Account (Store requirement)
            _SettingRow(
              icon: Icons.delete_outline_rounded,
              label: switch (locale) {
                SoulLocale.vi => 'Xóa tài khoản',
                SoulLocale.ko => '계정 삭제',
                SoulLocale.ja => 'アカウント削除',
                SoulLocale.fr => 'Supprimer le compte',
                SoulLocale.zh => '注销账号',
                SoulLocale.en => 'Delete Account',
              },
              onTap: () => _confirmDeleteAccount(context, ref, locale),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: l10n.signOutConfirmTitle,
      message: l10n.signOutConfirmBody,
      confirmLabel: l10n.signOut,
    );
    if (!confirmed) return;
    await ref.read(audioPlaybackProvider).stop();
    await ref.read(authControllerProvider.notifier).signOut();
    await ref.read(appStateProvider).resetAll();
    if (context.mounted) {
      context.go('/language');
    }
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
    SoulLocale locale,
  ) async {
    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: switch (locale) {
        SoulLocale.vi => 'Xóa tài khoản vĩnh viễn?',
        SoulLocale.ko => '계정을 영구 삭제하시겠습니까?',
        SoulLocale.ja => 'アカウントを完全に削除しますか？',
        SoulLocale.fr => 'Supprimer définitivement le compte ?',
        SoulLocale.zh => '确定永久注销账号吗？',
        SoulLocale.en => 'Delete account permanently?',
      },
      message: switch (locale) {
        SoulLocale.vi =>
          'Mọi dữ liệu cá nhân, nhật ký và bảng tầm nhìn sẽ bị xóa hoàn toàn khỏi thiết bị.',
        SoulLocale.ko => '모든 개인 데이터, 저널 및 비전 보드가 기기에서 완전히 삭제됩니다.',
        SoulLocale.ja => 'すべての個人データ、ジャーナル、ビジョンボードが完全に削除されます。',
        SoulLocale.fr =>
          'Toutes vos données personnelles et journaux seront définitivement supprimés.',
        SoulLocale.zh => '你的所有个人数据、日记和愿景板将从设备中完全清除。',
        SoulLocale.en =>
          'All personal data, journals, and vision boards will be permanently erased.',
      },
      confirmLabel: switch (locale) {
        SoulLocale.vi => 'Xóa tài khoản',
        SoulLocale.ko => '삭제',
        SoulLocale.ja => '削除',
        SoulLocale.fr => 'Supprimer',
        SoulLocale.zh => '注销',
        SoulLocale.en => 'Delete',
      },
    );
    if (!confirmed) return;
    await ref.read(audioPlaybackProvider).stop();
    await ref.read(authControllerProvider.notifier).deleteAccount();
    await ref.read(appStateProvider).resetAll();
    if (context.mounted) {
      context.go('/language');
    }
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SoulRadius.row),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SoulSpace.sm),
          child: Row(
            children: [
              Icon(icon, color: SoulColors.plum),
              const SizedBox(width: SoulSpace.md),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: SoulSpace.xs),
                Flexible(child: trailing!),
              ],
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: SoulColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
