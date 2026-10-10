import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_bottom_sheet.dart';
import '../payment/payment_controller.dart';
import '../payment/subscription_state.dart';
import 'language_suggestion.dart';
import 'onboarding_controllers.dart';
import 'preferred_name_validation.dart';

/// Language-neutral gate. Choices are shown as endonyms in a dropdown. The
/// device-suggested language pre-populates the dropdown, but no locale is
/// stored until the user confirms their choice.
class LanguageGateScreen extends ConsumerStatefulWidget {
  const LanguageGateScreen({super.key});

  static const _maxChoiceWidth = 280.0;

  @override
  ConsumerState<LanguageGateScreen> createState() => _LanguageGateScreenState();
}

class _LanguageGateScreenState extends ConsumerState<LanguageGateScreen> {
  SoulLocale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suggested = ref.watch(suggestedLocaleProvider);
    final effectiveLocale = _selectedLocale ?? suggested ?? SoulLocale.vi;
    final choices = {
      for (final locale in SoulLocale.values) locale: locale.endonym,
    };
    final continueLabel = effectiveLocale.continueLabel;

    return _OnboardingLayout(
      padding: const EdgeInsets.all(SoulSpace.xl),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Logo(width: 138, semanticLabel: l10n.appTitle),
        const SizedBox(height: SoulSpace.xl + SoulSpace.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LanguageGateScreen._maxChoiceWidth,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SoulSpace.md,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SoulRadius.input),
              border: Border.all(
                color: SoulColors.plum.withValues(alpha: 0.28),
                width: 1.4,
              ),
              boxShadow: SoulShadows.card,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SoulLocale>(
                value: effectiveLocale,
                isExpanded: true,
                borderRadius: BorderRadius.circular(SoulRadius.input),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: SoulColors.plum,
                ),
                items: [
                  for (final entry in choices.entries)
                    DropdownMenuItem<SoulLocale>(
                      value: entry.key,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 18,
                            color: SoulColors.plum,
                          ),
                          const SizedBox(width: SoulSpace.sm),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: SoulColors.plum,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedLocale = value);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: SoulSpace.md),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LanguageGateScreen._maxChoiceWidth,
          ),
          child: Column(
            children: [
              SoulButton(
                label: continueLabel,
                onPressed: () async {
                  await ref
                      .read(appStateProvider)
                      .selectLocale(effectiveLocale);
                  if (context.mounted) context.go('/onboarding/welcome');
                },
              ),
              const SizedBox(height: SoulSpace.xs),
              TextButton(
                onPressed:
                    () => showAuthBottomSheet(
                      context,
                      initialMode: AuthMode.signUp,
                      onSuccess: () {
                        if (context.mounted) {
                          if (ref.read(appStateProvider).onboardingCompleted) {
                            context.go('/app/today');
                          } else {
                            context.go('/onboarding/welcome');
                          }
                        }
                      },
                    ),
                child: Text(
                  switch (effectiveLocale) {
                    SoulLocale.vi => 'Đăng ký · Đăng nhập tài khoản',
                    SoulLocale.ko => '회원가입 · 로그인',
                    SoulLocale.ja => '新規登録 · ログイン',
                    SoulLocale.fr => 'Inscription · Connexion',
                    SoulLocale.zh => '注册 · 登录',
                    SoulLocale.en => 'Sign Up · Sign In',
                  },
                  style: const TextStyle(
                    color: SoulColors.plum,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Core value presentation: Welcome intro carousel introducing Soul,
/// the 28-day gratitude journey, and the vision board & soundscapes.
class WelcomeIntroScreen extends StatefulWidget {
  const WelcomeIntroScreen({super.key, this.isRevisiting = false});

  final bool isRevisiting;

  @override
  State<WelcomeIntroScreen> createState() => _WelcomeIntroScreenState();
}

class _WelcomeIntroScreenState extends State<WelcomeIntroScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (widget.isRevisiting) {
        Navigator.pop(context);
      } else {
        context.go('/onboarding/auth');
      }
    }
  }

  void _finish() {
    if (widget.isRevisiting) {
      Navigator.pop(context);
    } else {
      context.go('/onboarding/name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = [
      (
        icon: Icons.spa_outlined,
        title: l10n.welcomeTitle1,
        subtitle: l10n.welcomeSubtitle1,
        tag: 'SOUL SANCTUARY',
      ),
      (
        icon: Icons.favorite_outline_rounded,
        title: l10n.welcomeTitle2,
        subtitle: l10n.welcomeSubtitle2,
        tag: 'GRATITUDE PRACTICE',
      ),
      (
        icon: Icons.auto_awesome_outlined,
        title: l10n.welcomeTitle3,
        subtitle: l10n.welcomeSubtitle3,
        tag: 'VISION & SOUND',
      ),
    ];

    return Scaffold(
      appBar:
          widget.isRevisiting
              ? SoulAppBar(
                title: l10n.revisitOnboarding,
                onBack: () => Navigator.pop(context),
              )
              : null,
      body: SafeArea(
        child: Column(
          children: [
            if (!widget.isRevisiting)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: SoulSpace.sm,
                    right: SoulSpace.md,
                  ),
                  child: TextButton(
                    onPressed: _finish,
                    child: Text(
                      l10n.skipForNow,
                      style: const TextStyle(
                        color: SoulColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SoulSpace.xl,
                        vertical: SoulSpace.sm,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: SoulColors.lilac,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: SoulColors.plum.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              slide.icon,
                              size: 52,
                              color: SoulColors.plum,
                            ),
                          ),
                          const SizedBox(height: SoulSpace.xl),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SoulSpace.sm,
                              vertical: SoulSpace.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: SoulColors.surface,
                              borderRadius: BorderRadius.circular(
                                SoulRadius.button,
                              ),
                              border: Border.all(color: SoulColors.line),
                            ),
                            child: Text(
                              slide.tag,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                                color: SoulColors.muted,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: SoulSpace.md),
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: SoulSpace.md),
                          Text(
                            slide.subtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: SoulColors.softInk.withValues(alpha: 0.8),
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == i ? SoulColors.plum : SoulColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SoulSpace.xl),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SoulSpace.xl,
                0,
                SoulSpace.xl,
                SoulSpace.xl,
              ),
              child: SoulButton(
                label:
                    _currentPage == slides.length - 1
                        ? l10n.startJourney
                        : l10n.continueLabel,
                onPressed: _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks what Soul should call the user, right after the language choice
/// ([isEditing] false) or from Profile ([isEditing] true). Nothing is saved
/// until the user confirms.
class PreferredNameScreen extends ConsumerStatefulWidget {
  const PreferredNameScreen({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  ConsumerState<PreferredNameScreen> createState() =>
      _PreferredNameScreenState();
}

class _PreferredNameScreenState extends ConsumerState<PreferredNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(appStateProvider).preferredName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (validatePreferredName(_controller.text) != null) return;
    await ref.read(appStateProvider).savePreferredName(_controller.text);
    // After onboarding the router guard moves on to Today by itself.
    if (widget.isEditing && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final issue = validatePreferredName(_controller.text);
    final canSave = issue == null;
    final layout = _OnboardingLayout(
      currentStep: widget.isEditing ? null : 1,
      totalSteps: 4,
      children: [
        const Spacer(),
        Text(
          l10n.whatShouldWeCallYou,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.lg),
        SoulTextField(
          controller: _controller,
          label: l10n.nameHint,
          errorText:
              issue == PreferredNameIssue.tooLong
                  ? l10n.nameTooLong(preferredNameMaxLength)
                  : null,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => canSave ? _save() : null,
        ),
        const Spacer(),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label: widget.isEditing ? l10n.save : l10n.saveAndContinue,
          onPressed: canSave ? _save : null,
        ),
      ],
    );
    if (!widget.isEditing) return layout;
    return Scaffold(
      appBar: SoulAppBar(title: l10n.editName, onBack: () => context.pop()),
      body: layout,
    );
  }
}

/// Asks what brings the user to Soul. At least one intention is required;
/// several may be chosen.
class IntentionScreen extends ConsumerStatefulWidget {
  const IntentionScreen({super.key});

  @override
  ConsumerState<IntentionScreen> createState() => _IntentionScreenState();
}

class _IntentionScreenState extends ConsumerState<IntentionScreen> {
  late final Set<String> _selected = {...ref.read(appStateProvider).intentions};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.en;
    final intentions = ref.watch(intentionsProvider(locale));
    return _OnboardingLayout(
      currentStep: 2,
      totalSteps: 4,
      children: [
        _StepHeading(title: l10n.intentionTitle, body: l10n.intentionBody),
        const SizedBox(height: SoulSpace.lg),
        switch (intentions) {
          AsyncData(:final value) => Wrap(
            spacing: SoulSpace.xs,
            runSpacing: SoulSpace.xs,
            children: [
              for (final intention in value)
                SoulChip(
                  label: intention.label,
                  selected: _selected.contains(intention.code),
                  onSelected:
                      (selected) => setState(
                        () =>
                            selected
                                ? _selected.add(intention.code)
                                : _selected.remove(intention.code),
                      ),
                ),
            ],
          ),
          // The state views scroll, so they cannot sit in this column.
          AsyncError() => Column(
            children: [
              Text(l10n.somethingWentWrong, textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(intentionsProvider(locale)),
                child: Text(l10n.retry),
              ),
            ],
          ),
          _ => const SoulLoadingState(),
        },
        const SizedBox(height: SoulSpace.lg),
        if (_selected.isEmpty && intentions.hasValue) ...[
          Text(
            l10n.intentionChooseOne,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SoulSpace.xs),
        ],
        SoulButton(
          label: l10n.continueLabel,
          onPressed:
              _selected.isEmpty
                  ? null
                  : () => ref
                      .read(appStateProvider)
                      .saveIntentions(_selected.toList()),
        ),
      ],
    );
  }
}

/// Morning and evening reminder times, each of which can be turned off; the
/// whole step can be skipped.
class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  var _saving = false;

  Future<void> _finish(Future<void> Function() action) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final choices = ref.watch(reminderStepProvider);
    final controller = ref.read(reminderStepProvider.notifier);
    final labels = {
      ReminderKind.morning: l10n.reminderMorning,
      ReminderKind.evening: l10n.reminderEvening,
    };
    return _OnboardingLayout(
      currentStep: 3,
      totalSteps: 4,
      children: [
        _StepHeading(title: l10n.remindersTitle, body: l10n.remindersBody),
        const SizedBox(height: SoulSpace.lg),
        for (final MapEntry(key: kind, value: label) in labels.entries)
          _ReminderRow(
            label: label,
            choice: choices[kind]!,
            onEnabled: (enabled) => controller.setEnabled(kind, enabled),
            onTime: (time) => controller.setTime(kind, time),
          ),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label: l10n.continueLabel,
          onPressed: _saving ? null : () => _finish(controller.confirm),
        ),
        const SizedBox(height: SoulSpace.xs),
        SoulButton(
          label: l10n.skipForNow,
          variant: SoulButtonVariant.secondary,
          onPressed: _saving ? null : () => _finish(controller.skip),
        ),
      ],
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.label,
    required this.choice,
    required this.onEnabled,
    required this.onTime,
  });

  final String label;
  final ReminderChoice choice;
  final ValueChanged<bool> onEnabled;
  final ValueChanged<TimeOfDay> onTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(choice.time, alwaysUse24HourFormat: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: SoulSpace.xs),
      child: SoulCard(
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.md,
          vertical: SoulSpace.xxs,
        ),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Semantics(
              button: true,
              label: l10n.changeReminderTime(label, time),
              excludeSemantics: true,
              child: TextButton(
                onPressed:
                    choice.enabled
                        ? () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: choice.time,
                          );
                          if (picked != null) onTime(picked);
                        }
                        : null,
                child: Text(time),
              ),
            ),
            Semantics(
              label: label,
              child: Switch(value: choice.enabled, onChanged: onEnabled),
            ),
          ],
        ),
      ),
    );
  }
}

/// Final onboarding step: Commitment & Subscription Paywall ($2/mo, $20/yr, $50/lifetime).
class JourneyReadyScreen extends ConsumerStatefulWidget {
  const JourneyReadyScreen({super.key});

  @override
  ConsumerState<JourneyReadyScreen> createState() => _JourneyReadyScreenState();
}

class _JourneyReadyScreenState extends ConsumerState<JourneyReadyScreen> {
  String _selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final start = ref.watch(journeyStartProvider);
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
          SoulLocale.vi =>
            'Đồng hành bền bỉ 365 ngày cùng ước mơ · Tiết kiệm 17%',
          SoulLocale.ko => '365일 동안 꿈과 함께하는 꾸준한 여정 · 17% 할인',
          SoulLocale.ja => '365日、夢に寄り添う継続の旅 · 17%お得',
          SoulLocale.fr => '365 jours de fidélité à vos rêves · Économisez 17%',
          SoulLocale.zh => '365天坚定陪伴你的梦想 · 节省 17%',
          SoulLocale.en =>
            '365 days of steady devotion to your dreams · Save 17%',
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
          SoulLocale.vi =>
            'Cam kết một lần, sở hữu mãi mãi không gian bình yên',
          SoulLocale.ko => '한 번의 약속으로 평생 간직하는 평온한 안식처',
          SoulLocale.ja => '一度のコミットメントで、永遠にあなたの安らぎの空間へ',
          SoulLocale.fr => 'Un seul engagement, votre sanctuaire pour toujours',
          SoulLocale.zh => '一次承诺，永久拥有属于你的宁静空间',
          SoulLocale.en => 'One-time commitment, yours forever',
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
        'Thực hành biết ơn & nhật ký chuyển hóa tâm thức mỗi ngày',
        'Bảng tầm nhìn (Vision Board) & rút thẻ thông điệp tâm hồn',
        'Trọn bộ 28 không gian Góc nhỏ & âm thanh tần số 432Hz – 963Hz',
      ],
      SoulLocale.ko => const [
        '매일 감사 실천 및 마음 챙김 저널 기록',
        '무제한 비전 보드 및 데일리 소울 메시지 카드',
        '28개의 힐링 Little Corner 공간 및 432Hz – 963Hz 치유 주파수 사운드',
      ],
      SoulLocale.ja => const [
        '毎日の感謝ワークと心を整えるジャーナル記録',
        'ビジョンボード作成＆毎日のソウルメッセージカード',
        '全28のLittle Corner癒やし空間＆432Hz〜963Hzヒーリング周波数',
      ],
      SoulLocale.fr => const [
        'Pratique quotidienne de gratitude et journal de transformation',
        'Vision Board illimité et tirage quotidien de cartes Soul',
        'Les 28 espaces Little Corner et fréquences de guérison 432Hz – 963Hz',
      ],
      SoulLocale.zh => const [
        '每日感恩练习与正念转化日记',
        '无限愿景板 (Vision Board) 与每日心灵指引抽卡',
        '全部 28 个 Little Corner 疗愈空间与 432Hz – 963Hz 疗愈频率音频',
      ],
      SoulLocale.en => const [
        'Daily gratitude practice & mindful transformation journal',
        'Unlimited Vision Board & daily Soul guidance cards',
        'All 28 Little Corner sanctuaries & 432Hz – 963Hz healing frequencies',
      ],
    };

    return _OnboardingLayout(
      currentStep: 4,
      totalSteps: 4,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
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
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    switch (locale) {
                      SoulLocale.vi => 'CAM KẾT VỚI HÀNH TRÌNH',
                      SoulLocale.ko => '여정을 향한 약속',
                      SoulLocale.ja => '旅へのコミットメント',
                      SoulLocale.fr => 'ENGAGEMENT ENVERS VOTRE VOYAGE',
                      SoulLocale.zh => '对旅程的承诺',
                      SoulLocale.en => 'COMMIT TO YOUR JOURNEY',
                    },
                    style: textTheme.labelSmall?.copyWith(
                      color: SoulColors.plum,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: SoulSpace.xs),
        Text(
          l10n.journeyReadyTitle,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: SoulColors.plum,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.journeyReadyBody,
          style: textTheme.bodyMedium?.copyWith(
            color: SoulColors.softInk,
            height: 1.36,
          ),
        ),
        const SizedBox(height: SoulSpace.sm),

        // Compact Benefits Card
        SoulCard(
          color: SoulColors.softFill,
          padding: const EdgeInsets.symmetric(
            horizontal: SoulSpace.sm,
            vertical: SoulSpace.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < benefits.length; i++) ...[
                if (i > 0) const SizedBox(height: 4),
                Row(
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
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        benefits[i],
                        style: textTheme.labelMedium?.copyWith(
                          color: SoulColors.plum,
                          fontWeight: FontWeight.w600,
                          height: 1.28,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SoulSpace.sm),

        // 3 Pricing Tier Cards
        for (final plan in plans) ...[
          _SubscriptionPlanCard(
            title: plan.title,
            price: plan.price,
            subtitle: plan.subtitle,
            badge: plan.badge,
            selected: _selectedPlan == plan.id,
            onTap: () => setState(() => _selectedPlan = plan.id),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: SoulSpace.xs),
        if (start.hasError) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.somethingWentWrong,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: SoulColors.error),
            ),
          ),
          const SizedBox(height: SoulSpace.xs),
        ],
        SoulButton(
          label: start.hasError ? l10n.retry : l10n.beginDayOne,
          onPressed:
              start.isLoading
                  ? null
                  : () async {
                    if (_selectedPlan == 'lifetime') {
                      await ref
                          .read(paymentControllerProvider.notifier)
                          .purchase(_selectedPlan);
                    } else {
                      await ref
                          .read(paymentControllerProvider.notifier)
                          .startTrial(_selectedPlan);
                    }
                    await ref
                        .read(journeyStartProvider.notifier)
                        .start(_selectedPlan);
                  },
        ),
        const SizedBox(height: 8),
        Text(
          _selectedPlan == 'lifetime'
              ? (switch (locale) {
                SoulLocale.vi =>
                  'Thanh toán một lần duy nhất · Sở hữu vĩnh viễn.',
                SoulLocale.ko => '1회 결제로 평생 소장.',
                SoulLocale.ja => '1回のお支払いで、永久にご利用いただけます。',
                SoulLocale.fr => 'Paiement unique · Accès à vie garanti.',
                SoulLocale.zh => '一次性付费 · 终身永久使用。',
                SoulLocale.en =>
                  'One-time payment · Lifetime access guaranteed.',
              })
              : (switch (locale) {
                SoulLocale.vi =>
                  'Dùng thử 7 ngày miễn phí. Tự động thanh toán sau 7 ngày. Hủy bất cứ lúc nào.',
                SoulLocale.ko => '7일 무료 체험 후 자동 결제. 언제든지 취소 가능.',
                SoulLocale.ja => '7日間無料体験、その後自動更新。いつでも解約可能。',
                SoulLocale.fr =>
                  'Essai gratuit de 7 jours, puis facturé. Résiliable à tout moment.',
                SoulLocale.zh => '7天免费试用，之后按期扣费。可在设置中随时取消。',
                SoulLocale.en =>
                  '7-day free trial, then billed. Cancel anytime.',
              }),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11.5,
            color: SoulColors.muted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  const _SubscriptionPlanCard({
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
          horizontal: SoulSpace.sm,
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

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: textTheme.displaySmall),
        const SizedBox(height: SoulSpace.sm),
        Text(body, style: textTheme.bodyLarge),
      ],
    );
  }
}

/// Scrollable onboarding page: content is centered when it fits and scrolls
/// on small screens, at large text scales and above the keyboard.
class _OnboardingLayout extends StatelessWidget {
  const _OnboardingLayout({
    required this.children,
    this.padding = const EdgeInsets.all(SoulSpace.lg),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.currentStep,
    this.totalSteps = 4,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final int? currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (currentStep != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SoulSpace.lg,
                  SoulSpace.sm,
                  SoulSpace.lg,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: currentStep! / totalSteps,
                          backgroundColor: SoulColors.line,
                          color: SoulColors.plum,
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: SoulSpace.sm),
                    Text(
                      '$currentStep/$totalSteps',
                      style: const TextStyle(
                        fontSize: 11,
                        color: SoulColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: padding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: crossAxisAlignment,
                        children: children,
                      ),
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

class _Logo extends StatelessWidget {
  const _Logo({required this.width, required this.semanticLabel});

  final double width;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/soul_logo.png',
      width: width,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => Text(semanticLabel),
    );
  }
}
