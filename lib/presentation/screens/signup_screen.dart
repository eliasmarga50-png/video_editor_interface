import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/auth_providers.dart';
import '../../core/theme/theme.dart';
import '../../core/validators.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/cine_widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // The account is created and signed in; the router then opens Home.
    await ref.read(authControllerProvider.notifier).signUp(
          name: _name.text,
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authControllerProvider);
    final bool busy = auth.busy;

    return AuthShell(
      title: 'Create your account',
      subtitle: 'Generate and edit videos with AI in minutes',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(color: CineAITheme.textSecondary, fontSize: 13),
          ),
          TextButton(
            onPressed: busy
                ? null
                : () {
                    ref.read(authControllerProvider.notifier).clearError();
                    context.go('/login');
                  },
            child: const Text('Sign in'),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (auth.error != null) ...[
                AuthErrorBanner(message: auth.error!),
                const SizedBox(height: 14),
              ],
              AuthTextField(
                controller: _name,
                label: 'Name',
                icon: Icons.person_outline_rounded,
                enabled: !busy,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: Validators.name,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: _email,
                label: 'Email',
                icon: Icons.mail_outline_rounded,
                enabled: !busy,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: _password,
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                enabled: !busy,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                helperText: 'At least 8 characters, with a letter and a number',
                validator: Validators.newPassword,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: _confirm,
                label: 'Confirm password',
                icon: Icons.lock_reset_rounded,
                isPassword: true,
                enabled: !busy,
                textInputAction: TextInputAction.done,
                validator: Validators.confirm(() => _password.text),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 22),
              GradientButton(
                label: busy ? 'Creating account…' : 'Create account',
                icon: busy ? null : Icons.rocket_launch_rounded,
                onPressed: busy ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}