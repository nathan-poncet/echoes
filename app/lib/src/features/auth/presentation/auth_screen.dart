import 'package:echoes/src/common_widgets/feedback/progress/staggered_dots_wave_progress_indicator.dart';
import 'package:echoes/src/common_widgets/layout/responsive_center.dart';
import 'package:echoes/src/constants/breakpoints.dart';
import 'package:echoes/src/features/auth/presentation/auth_screen_controller.dart';
import 'package:echoes/src/features/auth/presentation/sign_in/auth_sign_in_form.dart';
import 'package:echoes/src/features/auth/presentation/sign_up/auth_sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.scrollController, this.initialType = AuthScreenType.signUp});
  final ScrollController? scrollController;
  final AuthScreenType initialType;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authScreenControllerProvider.notifier).set(widget.initialType);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pop this window when user loggin
    // ref.listen(tokenStateChangesProvider, (previous, next) {
    //   if (next.value != "") return context.pop();
    // });

    final screenType = ref.watch(authScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.close),
        ),
        title: Text(
          "Authentification",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: ResponsiveCenter(
        controller: widget.scrollController,
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(Sizes.p24),
        child: SafeArea(
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: switch (screenType) {
                AuthScreenType.signIn => const AuthSignInForm(),
                AuthScreenType.signUp => const AuthSignUpForm(),
                AuthScreenType.forgotPassword => const StaggeredDotsWaveProgressIndicator(),
              }),
        ),
      ),
    );
  }
}
