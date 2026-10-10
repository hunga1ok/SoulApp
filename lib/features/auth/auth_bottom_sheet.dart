import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import 'auth_controller.dart';
import 'auth_user.dart';

enum AuthMode { signUp, signIn }

/// Shows an elegant, calming modal bottom sheet for 1-tap Google/Apple/Email login & registration.
Future<bool?> showAuthBottomSheet(
  BuildContext context, {
  AuthMode initialMode = AuthMode.signUp,
  bool isLinking = false,
  VoidCallback? onSuccess,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => _AuthModalSheet(
          initialMode: initialMode,
          isLinking: isLinking,
          onSuccess: onSuccess,
        ),
  );
}

class _AuthModalSheet extends ConsumerStatefulWidget {
  const _AuthModalSheet({
    required this.initialMode,
    required this.isLinking,
    this.onSuccess,
  });

  final AuthMode initialMode;
  final bool isLinking;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<_AuthModalSheet> createState() => _AuthModalSheetState();
}

class _AuthModalSheetState extends ConsumerState<_AuthModalSheet> {
  late AuthMode _mode;
  bool _isLoading = false;
  bool _showEmailFields = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final name = ref.read(appStateProvider).preferredName;
      if (widget.isLinking) {
        await ref
            .read(authControllerProvider.notifier)
            .linkAccount(provider: AuthProvider.google, displayName: name);
      } else {
        await ref
            .read(authControllerProvider.notifier)
            .signInWithGoogle(displayName: name);
      }
      final user = ref.read(authControllerProvider);
      if (user.displayName != null &&
          !ref.read(appStateProvider).hasPreferredName) {
        await ref.read(appStateProvider).savePreferredName(user.displayName!);
      }
      if (mounted) {
        widget.onSuccess?.call();
        Navigator.pop(context, true);
      }
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
      final name = ref.read(appStateProvider).preferredName;
      if (widget.isLinking) {
        await ref
            .read(authControllerProvider.notifier)
            .linkAccount(provider: AuthProvider.apple, displayName: name);
      } else {
        await ref
            .read(authControllerProvider.notifier)
            .signInWithApple(displayName: name);
      }
      final user = ref.read(authControllerProvider);
      if (user.displayName != null &&
          !ref.read(appStateProvider).hasPreferredName) {
        await ref.read(appStateProvider).savePreferredName(user.displayName!);
      }
      if (mounted) {
        widget.onSuccess?.call();
        Navigator.pop(context, true);
      }
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
      final currentName = ref.read(appStateProvider).preferredName;
      final name =
          _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : (currentName ?? '');

      if (_mode == AuthMode.signUp) {
        await ref
            .read(authControllerProvider.notifier)
            .signUpWithEmail(
              email: email,
              password: password,
              displayName: name.isNotEmpty ? name : null,
            );
      } else {
        await ref
            .read(authControllerProvider.notifier)
            .signInWithEmail(
              email: email,
              password: password,
              displayName: name.isNotEmpty ? name : null,
            );
      }

      final user = ref.read(authControllerProvider);
      if (user.displayName != null &&
          !ref.read(appStateProvider).hasPreferredName) {
        await ref.read(appStateProvider).savePreferredName(user.displayName!);
      }

      if (mounted) {
        widget.onSuccess?.call();
        Navigator.pop(context, true);
      }
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
    final theme = Theme.of(context);

    final title =
        widget.isLinking
            ? switch (locale) {
              SoulLocale.vi => 'Liên kết tài khoản',
              SoulLocale.ko => '계정 연동하기',
              SoulLocale.ja => 'アカウント連携',
              SoulLocale.fr => 'Lier le compte',
              SoulLocale.zh => '关联账号',
              SoulLocale.en => 'Link Account',
            }
            : _mode == AuthMode.signUp
            ? switch (locale) {
              SoulLocale.vi => 'Tạo tài khoản Soul',
              SoulLocale.ko => 'Soul 계정 만들기',
              SoulLocale.ja => 'Soulアカウントを作成',
              SoulLocale.fr => 'Créer un compte Soul',
              SoulLocale.zh => '创建 Soul 账号',
              SoulLocale.en => 'Create your Soul account',
            }
            : switch (locale) {
              SoulLocale.vi => 'Đăng nhập vào Soul',
              SoulLocale.ko => 'Soul 로그인',
              SoulLocale.ja => 'Soulにログイン',
              SoulLocale.fr => 'Connexion à Soul',
              SoulLocale.zh => '登录 Soul',
              SoulLocale.en => 'Sign In to Soul',
            };

    final subtitle =
        widget.isLinking
            ? switch (locale) {
              SoulLocale.vi =>
                'Lưu trữ an toàn nhật ký, tầm nhìn và bảo lưu gói mua trọn đời trên mọi thiết bị.',
              SoulLocale.ko => '모든 기기에서 저널, 비전 및 구독 혜택을 안전하게 보관하세요.',
              SoulLocale.ja => 'すべてのデバイスでジャーナル、ビジョン、購入内容を安全に同期します。',
              SoulLocale.fr =>
                'Sauvegardez vos journaux, visions et forfaits sur tous vos appareils.',
              SoulLocale.zh => '在所有设备上安全备份你的日记、愿景与会员权益。',
              SoulLocale.en =>
                'Safely keep your journals, visions, and purchases synced across all devices.',
            }
            : _mode == AuthMode.signUp
            ? switch (locale) {
              SoulLocale.vi =>
                'Khởi đầu hành trình nuôi dưỡng bình yên và lưu trữ dữ liệu an toàn.',
              SoulLocale.ko => '평온한 여정을 시작하고 데이터를 안전하게 보관하세요.',
              SoulLocale.ja => '穏やかな旅を始め、データを安全にバックアップしましょう。',
              SoulLocale.fr =>
                'Commencez votre voyage serein et sécurisez vos données.',
              SoulLocale.zh => '开启滋养心灵的宁静旅程，安全备份你的个人成长数据。',
              SoulLocale.en =>
                'Begin your peaceful journey and safely keep your growth in sync.',
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
            };

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        SoulSpace.xl,
        SoulSpace.lg,
        SoulSpace.xl,
        SoulSpace.xl + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 30,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grabber handle
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

            // Soul Logo or Icon
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF9E8F5), Color(0xFFFFF0E4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2BEDC).withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: SoulColors.plum,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(height: SoulSpace.sm),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: SoulColors.plum,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: SoulColors.muted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: SoulSpace.md),

            // Segmented Switcher [ Đăng ký | Đăng nhập ] (if not linking)
            if (!widget.isLinking) ...[
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
                      child: _ModeTabButton(
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
                      child: _ModeTabButton(
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
            ],

            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(SoulSpace.sm),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(SoulRadius.button),
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
                  child: CircularProgressIndicator(color: SoulColors.plum),
                ),
              )
            else ...[
              // 1. Google 1-Tap button
              _SocialAuthButton(
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

              // 2. Apple 1-Tap button
              _SocialAuthButton(
                icon: const Icon(Icons.apple, color: Colors.white, size: 22),
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

              // 3. Email Toggle
              if (!_showEmailFields)
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showEmailFields = true),
                  icon: const Icon(Icons.mail_outline_rounded, size: 18),
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
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                    ),
                  ),
                )
              else ...[
                // Email fields form
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

              const SizedBox(height: SoulSpace.md),

              // Bottom Cancel / Guest note
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  switch (locale) {
                    SoulLocale.vi => 'Để sau, tiếp tục với tư cách Khách',
                    SoulLocale.ko => '나중에 하기 (게스트로 계속)',
                    SoulLocale.ja => '後で（ゲストとして続ける）',
                    SoulLocale.fr => 'Plus tard (continuer en invité)',
                    SoulLocale.zh => '稍后再说（以访客身份继续）',
                    SoulLocale.en => 'Maybe later (continue as guest)',
                  },
                  style: const TextStyle(
                    color: SoulColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModeTabButton extends StatelessWidget {
  const _ModeTabButton({
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

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
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
