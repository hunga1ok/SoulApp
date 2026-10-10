import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../auth/auth_bottom_sheet.dart';
import '../auth/auth_controller.dart';

/// Dedicated Onboarding screen for new users to Sign Up or Sign In before
/// choosing what Soul should call them.
class OnboardingAuthScreen extends ConsumerStatefulWidget {
  const OnboardingAuthScreen({super.key});

  @override
  ConsumerState<OnboardingAuthScreen> createState() =>
      _OnboardingAuthScreenState();
}

class _OnboardingAuthScreenState extends ConsumerState<OnboardingAuthScreen> {
  AuthMode _mode = AuthMode.signUp;
  bool _isLoading = false;
  bool _showEmailFields = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authControllerProvider);
      if (!auth.isGuest && mounted) {
        context.go('/onboarding/name');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSuccess() {
    final user = ref.read(authControllerProvider);
    if (user.displayName != null &&
        !ref.read(appStateProvider).hasPreferredName) {
      ref.read(appStateProvider).savePreferredName(user.displayName!);
    }
    if (mounted) context.go('/onboarding/name');
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final currentName = ref.read(appStateProvider).preferredName;
      await ref
          .read(authControllerProvider.notifier)
          .signInWithGoogle(
            displayName:
                currentName != null && currentName.isNotEmpty
                    ? currentName
                    : null,
          );
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) {
        final locale = ref.read(appStateProvider).locale ?? SoulLocale.vi;
        setState(() {
          _errorMessage = switch (locale) {
            SoulLocale.vi =>
              'Không thể đăng nhập Google lúc này. Vui lòng thử lại.',
            SoulLocale.ko => '지금은 Google 로그인을 진행할 수 없습니다. 다시 시도해 주세요.',
            SoulLocale.ja => '現在 Google ログインを利用できません。もう一度お試しください。',
            SoulLocale.fr =>
              'Impossible de se connecter avec Google pour le moment.',
            SoulLocale.zh => '当前无法使用 Google 登录，请稍后重试。',
            SoulLocale.en =>
              'Unable to sign in with Google at this time. Please try again.',
          };
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final currentName = ref.read(appStateProvider).preferredName;
      await ref
          .read(authControllerProvider.notifier)
          .signInWithApple(
            displayName:
                currentName != null && currentName.isNotEmpty
                    ? currentName
                    : null,
          );
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) {
        final locale = ref.read(appStateProvider).locale ?? SoulLocale.vi;
        setState(() {
          _errorMessage = switch (locale) {
            SoulLocale.vi =>
              'Không thể đăng nhập Apple lúc này. Vui lòng thử lại.',
            SoulLocale.ko => '지금은 Apple 로그인을 진행할 수 없습니다. 다시 시도해 주세요.',
            SoulLocale.ja => '現在 Apple ログインを利用できません。もう一度お試しください。',
            SoulLocale.fr =>
              'Impossible de se connecter avec Apple pour le moment.',
            SoulLocale.zh => '当前无法使用 Apple 登录，请稍后重试。',
            SoulLocale.en =>
              'Unable to sign in with Apple at this time. Please try again.',
          };
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEmailSubmit(SoulLocale locale) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _errorMessage = switch (locale) {
          SoulLocale.vi => 'Vui lòng nhập địa chỉ email hợp lệ.',
          SoulLocale.ko => '올바른 이메일 주소를 입력해 주세요.',
          SoulLocale.ja => '有効なメールアドレスを入力してください。',
          SoulLocale.fr => 'Veuillez entrer une adresse e-mail valide.',
          SoulLocale.zh => '请输入有效的电子邮箱地址。',
          SoulLocale.en => 'Please enter a valid email address.',
        };
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        _errorMessage = switch (locale) {
          SoulLocale.vi => 'Mật khẩu phải có tối thiểu 6 ký tự.',
          SoulLocale.ko => '비밀번호는 최소 6자 이상이어야 합니다.',
          SoulLocale.ja => 'パスワードは6文字以上である必要があります。',
          SoulLocale.fr =>
            'Le mot de passe doit comporter au moins 6 caractères.',
          SoulLocale.zh => '密码长度至少需为 6 位。',
          SoulLocale.en => 'Password must be at least 6 characters.',
        };
      });
      return;
    }

    if (_mode == AuthMode.signUp && password != confirmPassword) {
      setState(() {
        _errorMessage = switch (locale) {
          SoulLocale.vi => 'Mật khẩu xác nhận không khớp.',
          SoulLocale.ko => '비밀번호가 일치하지 않습니다.',
          SoulLocale.ja => 'パスワードが一致しません。',
          SoulLocale.fr => 'Les mots de passe ne correspondent pas.',
          SoulLocale.zh => '两次输入的密码不一致。',
          SoulLocale.en => 'Passwords do not match.',
        };
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (_mode == AuthMode.signUp) {
        await ref
            .read(authControllerProvider.notifier)
            .signUpWithEmail(email: email, password: password);
      } else {
        await ref
            .read(authControllerProvider.notifier)
            .signInWithEmail(email: email, password: password);
      }
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = switch (locale) {
            SoulLocale.vi =>
              _mode == AuthMode.signUp
                  ? 'Đã có lỗi khi tạo tài khoản.'
                  : 'Đã có lỗi khi đăng nhập email.',
            SoulLocale.ko =>
              _mode == AuthMode.signUp
                  ? '계정 생성 중 오류가 발생했습니다.'
                  : '이메일 로그인 중 오류가 발생했습니다.',
            SoulLocale.ja =>
              _mode == AuthMode.signUp
                  ? 'アカウント作成中にエラーが発生しました。'
                  : 'ログイン中にエラーが発生しました。',
            SoulLocale.fr =>
              _mode == AuthMode.signUp
                  ? 'Erreur lors de la création du compte.'
                  : 'Erreur lors de la connexion par e-mail.',
            SoulLocale.zh =>
              _mode == AuthMode.signUp ? '创建账号时出错，请重试。' : '邮箱登录失败，请重试。',
            SoulLocale.en =>
              _mode == AuthMode.signUp
                  ? 'An error occurred while creating your account.'
                  : 'An error occurred during email sign-in.',
          };
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SoulSpace.xl,
                  vertical: SoulSpace.lg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),

                    // Logo Icon
                    Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF9E8F5), Color(0xFFFFF0E4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(
                              0xFFE2BEDC,
                            ).withValues(alpha: 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SoulColors.plum.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: SoulColors.plum,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: SoulSpace.md),

                    // Title
                    Text(
                      _mode == AuthMode.signUp
                          ? switch (locale) {
                            SoulLocale.vi => 'Tạo tài khoản Soul',
                            SoulLocale.ko => 'Soul 계정 만들기',
                            SoulLocale.ja => 'Soulアカウントを作成',
                            SoulLocale.fr => 'Créer un compte Soul',
                            SoulLocale.zh => '创建 Soul 账号',
                            SoulLocale.en => 'Create your Soul account',
                          }
                          : switch (locale) {
                            SoulLocale.vi => 'Chào mừng trở lại',
                            SoulLocale.ko => '다시 오신 것을 환영합니다',
                            SoulLocale.ja => 'お帰りなさい',
                            SoulLocale.fr => 'Bon retour parmi nous',
                            SoulLocale.zh => '欢迎回来',
                            SoulLocale.en => 'Welcome back',
                          },
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SoulColors.plum,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _mode == AuthMode.signUp
                          ? switch (locale) {
                            SoulLocale.vi =>
                              'Lưu giữ an toàn nhật ký, bảng tầm nhìn và đồng bộ trên mọi thiết bị.',
                            SoulLocale.ko =>
                              '모든 기기에서 저널, 비전 및 구독 혜택을 안전하게 동기화하세요.',
                            SoulLocale.ja =>
                              'すべてのデバイスでジャーナル、ビジョン、購入内容を安全に同期します。',
                            SoulLocale.fr =>
                              'Sauvegardez vos journaux, visions et forfaits sur tous vos appareils.',
                            SoulLocale.zh => '在所有设备上安全备份你的日记、愿景与会员权益。',
                            SoulLocale.en =>
                              'Safely keep your journals, visions, and sync across all devices.',
                          }
                          : switch (locale) {
                            SoulLocale.vi =>
                              'Đồng bộ dữ liệu của bạn và tiếp tục hành trình nuôi dưỡng bình yên.',
                            SoulLocale.ko => '데이터를 동기화하고 평온한 여정을 이어가세요.',
                            SoulLocale.ja => 'データを同期して、穏やかな旅を続けましょう。',
                            SoulLocale.fr =>
                              'Synchronisez vos données et continuez votre voyage serein.',
                            SoulLocale.zh => '同步你的数据，继续这段滋养心灵的宁静旅程。',
                            SoulLocale.en =>
                              'Sync your data and continue your gentle journey of peace.',
                          },
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: SoulColors.muted,
                        height: 1.38,
                      ),
                    ),
                    const SizedBox(height: SoulSpace.lg),

                    // Segmented Switcher [ Đăng ký | Đăng nhập ]
                    Container(
                      padding: const EdgeInsets.all(3.5),
                      decoration: BoxDecoration(
                        color: SoulColors.softFill,
                        borderRadius: BorderRadius.circular(SoulRadius.button),
                        border: Border.all(color: SoulColors.line),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _OnboardingModeTab(
                              label: switch (locale) {
                                SoulLocale.vi => 'Đăng ký',
                                SoulLocale.ko => '회원가입',
                                SoulLocale.ja => '新規登録',
                                SoulLocale.fr => "S'inscrire",
                                SoulLocale.zh => '注册',
                                SoulLocale.en => 'Sign Up',
                              },
                              isSelected: _mode == AuthMode.signUp,
                              onTap: () {
                                if (_mode != AuthMode.signUp) {
                                  setState(() {
                                    _mode = AuthMode.signUp;
                                    _errorMessage = null;
                                  });
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: _OnboardingModeTab(
                              label: switch (locale) {
                                SoulLocale.vi => 'Đăng nhập',
                                SoulLocale.ko => '로그인',
                                SoulLocale.ja => 'ログイン',
                                SoulLocale.fr => 'Connexion',
                                SoulLocale.zh => '登录',
                                SoulLocale.en => 'Sign In',
                              },
                              isSelected: _mode == AuthMode.signIn,
                              onTap: () {
                                if (_mode != AuthMode.signIn) {
                                  setState(() {
                                    _mode = AuthMode.signIn;
                                    _errorMessage = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SoulSpace.md),

                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(SoulSpace.sm),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(
                            SoulRadius.button,
                          ),
                          border: Border.all(color: const Color(0xFFFFCDD2)),
                        ),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFC62828),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: SoulSpace.md),
                    ],

                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(SoulSpace.xl),
                          child: CircularProgressIndicator(
                            color: SoulColors.plum,
                          ),
                        ),
                      )
                    else ...[
                      // 1. Google 1-Tap
                      _OnboardingSocialButton(
                        icon: Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Color(0xFF4285F4),
                            ),
                          ),
                        ),
                        label:
                            _mode == AuthMode.signUp
                                ? switch (locale) {
                                  SoulLocale.vi => 'Đăng ký với Google',
                                  SoulLocale.ko => 'Google로 가입하기',
                                  SoulLocale.ja => 'Googleで登録',
                                  SoulLocale.fr => "S'inscrire avec Google",
                                  SoulLocale.zh => '使用 Google 注册',
                                  SoulLocale.en => 'Sign up with Google',
                                }
                                : switch (locale) {
                                  SoulLocale.vi => 'Tiếp tục với Google',
                                  SoulLocale.ko => 'Google로 계속하기',
                                  SoulLocale.ja => 'Googleで続ける',
                                  SoulLocale.fr => 'Continuer avec Google',
                                  SoulLocale.zh => '使用 Google 继续',
                                  SoulLocale.en => 'Continue with Google',
                                },
                        backgroundColor: Colors.white,
                        textColor: const Color(0xFF3C4043),
                        borderColor: const Color(0xFFDADCE0),
                        onTap: _handleGoogleSignIn,
                      ),
                      const SizedBox(height: SoulSpace.sm),

                      // 2. Apple 1-Tap
                      _OnboardingSocialButton(
                        icon: const Icon(
                          Icons.apple,
                          color: Colors.white,
                          size: 22,
                        ),
                        label:
                            _mode == AuthMode.signUp
                                ? switch (locale) {
                                  SoulLocale.vi => 'Đăng ký với Apple',
                                  SoulLocale.ko => 'Apple로 가입하기',
                                  SoulLocale.ja => 'Appleで登録',
                                  SoulLocale.fr => "S'inscrire avec Apple",
                                  SoulLocale.zh => '使用 Apple 注册',
                                  SoulLocale.en => 'Sign up with Apple',
                                }
                                : switch (locale) {
                                  SoulLocale.vi => 'Tiếp tục với Apple',
                                  SoulLocale.ko => 'Apple로 계속하기',
                                  SoulLocale.ja => 'Appleで続ける',
                                  SoulLocale.fr => 'Continuer avec Apple',
                                  SoulLocale.zh => '使用 Apple 继续',
                                  SoulLocale.en => 'Continue with Apple',
                                },
                        backgroundColor: const Color(0xFF160F16),
                        textColor: Colors.white,
                        borderColor: Colors.transparent,
                        onTap: _handleAppleSignIn,
                      ),
                      const SizedBox(height: SoulSpace.sm),

                      // 3. Email Toggle / Fields
                      if (!_showEmailFields)
                        OutlinedButton.icon(
                          onPressed:
                              () => setState(() => _showEmailFields = true),
                          icon: const Icon(
                            Icons.mail_outline_rounded,
                            size: 18,
                          ),
                          label: Text(
                            _mode == AuthMode.signUp
                                ? switch (locale) {
                                  SoulLocale.vi => 'Đăng ký bằng Email',
                                  SoulLocale.ko => '이메일로 가입하기',
                                  SoulLocale.ja => 'メールで登録',
                                  SoulLocale.fr => 'Inscription par e-mail',
                                  SoulLocale.zh => '使用邮箱注册',
                                  SoulLocale.en => 'Sign up with Email',
                                }
                                : switch (locale) {
                                  SoulLocale.vi => 'Đăng nhập bằng Email',
                                  SoulLocale.ko => '이메일로 로그인',
                                  SoulLocale.ja => 'メールでログイン',
                                  SoulLocale.fr => 'Connexion par e-mail',
                                  SoulLocale.zh => '使用邮箱登录',
                                  SoulLocale.en => 'Sign in with Email',
                                },
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: SoulColors.plum,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: SoulColors.line),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SoulRadius.button,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        SoulTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: SoulSpace.xs),
                        SoulTextField(
                          controller: _passwordController,
                          label: switch (locale) {
                            SoulLocale.vi => 'Mật khẩu (tối thiểu 6 ký tự)',
                            SoulLocale.ko => '비밀번호 (최소 6자)',
                            SoulLocale.ja => 'パスワード (6文字以上)',
                            SoulLocale.fr => 'Mot de passe (min 6 caractères)',
                            SoulLocale.zh => '密码（至少 6 位）',
                            SoulLocale.en => 'Password (min 6 chars)',
                          },
                          obscureText: true,
                        ),
                        if (_mode == AuthMode.signUp) ...[
                          const SizedBox(height: SoulSpace.xs),
                          SoulTextField(
                            controller: _confirmPasswordController,
                            label: switch (locale) {
                              SoulLocale.vi => 'Xác nhận lại mật khẩu',
                              SoulLocale.ko => '비밀번호 재확인',
                              SoulLocale.ja => 'パスワードの再確認',
                              SoulLocale.fr => 'Confirmer le mot de passe',
                              SoulLocale.zh => '确认密码',
                              SoulLocale.en => 'Confirm password',
                            },
                            obscureText: true,
                          ),
                        ],
                        const SizedBox(height: SoulSpace.sm),
                        SoulButton(
                          label:
                              _mode == AuthMode.signUp
                                  ? switch (locale) {
                                    SoulLocale.vi => 'Tạo tài khoản',
                                    SoulLocale.ko => '계정 생성하기',
                                    SoulLocale.ja => 'アカウントを作成',
                                    SoulLocale.fr => 'Créer un compte',
                                    SoulLocale.zh => '创建账号',
                                    SoulLocale.en => 'Create Account',
                                  }
                                  : switch (locale) {
                                    SoulLocale.vi => 'Xác nhận đăng nhập',
                                    SoulLocale.ko => '로그인 확인',
                                    SoulLocale.ja => 'ログインを確認',
                                    SoulLocale.fr => 'Confirmer la connexion',
                                    SoulLocale.zh => '确认登录',
                                    SoulLocale.en => 'Confirm Sign In',
                                  },
                          onPressed: () => _handleEmailSubmit(locale),
                        ),
                      ],
                    ],

                    const Spacer(),
                    const SizedBox(height: SoulSpace.md),

                    // Continue as guest
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/onboarding/name'),
                        child: Text(
                          switch (locale) {
                            SoulLocale.vi =>
                              'Để sau, tiếp tục với tư cách Khách',
                            SoulLocale.ko => '나중에 하기 (게스트로 계속)',
                            SoulLocale.ja => '後で（ゲストとして続ける）',
                            SoulLocale.fr => 'Plus tard (continuer en invité)',
                            SoulLocale.zh => '稍后再说（以访客身份继续）',
                            SoulLocale.en => 'Maybe later (continue as guest)',
                          },
                          style: const TextStyle(
                            color: SoulColors.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingModeTab extends StatelessWidget {
  const _OnboardingModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.button - 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? SoulColors.plum : Colors.transparent,
          borderRadius: BorderRadius.circular(SoulRadius.button - 2),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: SoulColors.plum.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : SoulColors.muted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}

class _OnboardingSocialButton extends StatelessWidget {
  const _OnboardingSocialButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.button),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(SoulRadius.button),
          border: Border.all(color: borderColor, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
