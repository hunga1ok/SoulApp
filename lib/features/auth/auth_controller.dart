import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_user.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthUser>(
  AuthController.new,
);

class AuthController extends Notifier<AuthUser> {
  late final AuthRepository _repository;

  @override
  AuthUser build() {
    _repository = ref.watch(authRepositoryProvider);
    return _repository.currentUser;
  }

  Future<void> signInWithGoogle({String? email, String? displayName}) async {
    final updated = await _repository.signInWithGoogle(
      email: email,
      displayName: displayName,
    );
    state = updated;
    if (updated.displayName != null && updated.displayName!.isNotEmpty) {
      await ref.read(appStateProvider).savePreferredName(updated.displayName!);
    }
  }

  Future<void> signInWithApple({String? email, String? displayName}) async {
    final updated = await _repository.signInWithApple(
      email: email,
      displayName: displayName,
    );
    state = updated;
    if (updated.displayName != null && updated.displayName!.isNotEmpty) {
      await ref.read(appStateProvider).savePreferredName(updated.displayName!);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final updated = await _repository.signInWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    state = updated;
    if (updated.displayName != null && updated.displayName!.isNotEmpty) {
      await ref.read(appStateProvider).savePreferredName(updated.displayName!);
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final updated = await _repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    state = updated;
    if (updated.displayName != null && updated.displayName!.isNotEmpty) {
      await ref.read(appStateProvider).savePreferredName(updated.displayName!);
    }
  }

  Future<void> linkAccount({
    required AuthProvider provider,
    String? email,
    String? displayName,
  }) async {
    final updated = await _repository.linkAccount(
      provider: provider,
      email: email,
      displayName: displayName,
    );
    state = updated;
    if (updated.displayName != null && updated.displayName!.isNotEmpty) {
      await ref.read(appStateProvider).savePreferredName(updated.displayName!);
    }
  }

  Future<void> signOut() async {
    final guest = await _repository.signOut();
    state = guest;
  }

  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
    state = _repository.currentUser;
  }
}
