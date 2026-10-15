import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/auth_providers.dart';
import '../../core/theme/theme.dart';
import '../../core/validators.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/cine_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // On success the router redirect moves the user to Home.
    await ref.read(authControllerProvider.notifier).signIn(
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authControllerProvider);
    final bool busy = auth.busy;

    return AuthShell(
      title: 'Welcome back',
      subtitle: 'Sign in to keep creating with AI',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'New to CineAI?',
            style: TextStyle(color: CineAITheme.textSecondary, fontSize: 13),
          ),
          TextButton(
            onPressed: busy
                ? null
                : () {
                    ref.read(authControllerProvider.notifier).clearError();
                    context.go('/signup');
                  },
            child: const Text('Create account'),
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
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: Validators.required,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 22),
              GradientButton(
                label: busy ? 'Signing in…' : 'Sign in',
                icon: busy ? null : Icons.login_rounded,
                onPressed: busy ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}