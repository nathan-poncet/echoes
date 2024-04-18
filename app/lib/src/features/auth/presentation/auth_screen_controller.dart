import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_screen_controller.g.dart';

enum AuthScreenType { signIn, signUp, forgotPassword }

@riverpod
class AuthScreenController extends _$AuthScreenController {
  @override
  AuthScreenType build() {
    return AuthScreenType.signIn;
  }

  void set(AuthScreenType type) {
    state = type;
  }
}
