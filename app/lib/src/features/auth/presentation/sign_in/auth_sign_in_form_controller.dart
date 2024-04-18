import 'dart:async';

import 'package:echoes/src/api/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_sign_in_form_controller.g.dart';

@riverpod
class AuthSignInFormController extends _$AuthSignInFormController {
  bool _mounted = true;

  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      _mounted = false;
    });

    return null;
  }

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => _signInWithEmail(email: email, password: password));

    if (_mounted) {
      state = newState;
    }
  }

  Future<void> _signInWithEmail({
    required String email,
    required String password,
  }) async {
    final pb = ref.read(pocketBaseProvider);

    await pb.collection('users').authWithPassword(email, password);
  }
}
