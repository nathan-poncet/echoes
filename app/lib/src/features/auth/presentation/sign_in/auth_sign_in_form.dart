import 'package:echoes/src/common_widgets/feedback/progress/staggered_dots_wave_progress_indicator.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/features/auth/presentation/auth_screen_controller.dart';
import 'package:echoes/src/features/auth/presentation/sign_in/auth_sign_in_form_controller.dart';
import 'package:echoes/src/utils/async_value_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AuthSignInForm extends ConsumerStatefulWidget {
  const AuthSignInForm({super.key});

  @override
  ConsumerState<AuthSignInForm> createState() => _AuthSignInFormState();
}

class _AuthSignInFormState extends ConsumerState<AuthSignInForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submit() async {
    // only submit the form if validation passes
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final controller = ref.read(authSignInFormControllerProvider.notifier);
      await controller.submit(email: _formKey.currentState?.fields['email']?.value, password: _formKey.currentState?.fields['password']?.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authSignInFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(authSignInFormControllerProvider);
    return Column(
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'email',
                autofillHints: const [AutofillHints.username],
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              gapH12,
              FormBuilderTextField(
                name: 'password',
                autofillHints: const [AutofillHints.password],
                decoration: const InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              ),
              gapH32,
              ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                child: state.isLoading ? const StaggeredDotsWaveProgressIndicator(size: Sizes.p20) : const Text("Connexion"),
              ),
            ],
          ),
        ),
        gapH16,
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Tu n'as pas de compte ?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextSpan(text: " ", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)),
            TextSpan(
              text: "Inscris-toi",
              recognizer: TapGestureRecognizer()..onTap = () => ref.read(authScreenControllerProvider.notifier).set(AuthScreenType.signUp),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ]),
        ),
      ],
    );
  }
}
