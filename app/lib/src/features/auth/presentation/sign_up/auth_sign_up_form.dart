import 'package:echoes/src/common_widgets/feedback/progress/staggered_dots_wave_progress_indicator.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/features/auth/presentation/auth_screen_controller.dart';
import 'package:echoes/src/features/auth/presentation/sign_up/auth_sign_up_form_controller.dart';
import 'package:echoes/src/utils/async_value_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AuthSignUpForm extends ConsumerStatefulWidget {
  const AuthSignUpForm({super.key});

  @override
  ConsumerState<AuthSignUpForm> createState() => _AuthSignUpFormState();
}

class _AuthSignUpFormState extends ConsumerState<AuthSignUpForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submit() async {
    // only submit the form if validation passes
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final controller = ref.read(authSignUpFormControllerProvider.notifier);
      await controller.submit(
          name: _formKey.currentState?.fields['name']?.value,
          email: _formKey.currentState?.fields['email']?.value,
          password: _formKey.currentState?.fields['password']?.value,
          confirmPassword: _formKey.currentState?.fields['confirmPassword']?.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authSignUpFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(authSignUpFormControllerProvider);
    return Column(
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'name',
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(labelText: "Nom"),
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              ),
              gapH12,
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
                validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.minLength(6)]),
              ),
              gapH12,
              FormBuilderTextField(
                name: 'confirmPassword',
                autofillHints: const [AutofillHints.password],
                decoration: const InputDecoration(labelText: "Confirmer le mot de passe"),
                obscureText: true,
                validator: (value) => _formKey.currentState?.fields['password']?.value != value ? "Les mots de passe ne correspondent pas" : null,
              ),
              gapH32,
              ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                child: state.isLoading ? const StaggeredDotsWaveProgressIndicator(size: Sizes.p20) : const Text("Créer un compte"),
              ),
            ],
          ),
        ),
        gapH16,
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Tu as déjà un compte ?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextSpan(text: " ", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)),
            TextSpan(
              text: "Connecte-toi",
              recognizer: TapGestureRecognizer()..onTap = () => ref.read(authScreenControllerProvider.notifier).set(AuthScreenType.signIn),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ]),
        ),
        TextButton(
            onPressed: () {
              ref.read(authScreenControllerProvider.notifier).set(AuthScreenType.forgotPassword);
            },
            child: Text("Mot de passe oublié ?", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor))),
      ],
    );
  }
}
