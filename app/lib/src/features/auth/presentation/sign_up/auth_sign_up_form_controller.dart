import 'dart:async';

import 'package:echoes/src/api/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_sign_up_form_controller.g.dart';

@riverpod
class AuthSignUpFormController extends _$AuthSignUpFormController {
  bool _mounted = true;

  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      _mounted = false;
    });

    return null;
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => _signUpWithEmail(name: name, email: email, password: password, confirmPassword: confirmPassword));

    if (_mounted) {
      state = newState;
    }
  }

  Future<void> _signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final pb = ref.read(pocketBaseProvider);

    await pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': confirmPassword,
      'name': name,
    });

    await pb.collection('users').authWithPassword(email, password);
  }
}
