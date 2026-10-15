import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import 'cine_widgets.dart';

/// Shared layout for the sign-in and sign-up screens.
class AuthShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget footer;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -.8),
                  radius: 1.2,
                  colors: [
                    CineAITheme.violet.withValues(alpha: .18),
                    CineAITheme.background,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: CineAITheme.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: CineAITheme.glow(alpha: .35, blur: 22),
                        ),
                        child: const Icon(
                          Icons.movie_filter_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CineAITheme.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppCard(
                        padding: const EdgeInsets.all(20),
                        child: child,
                      ),
                      const SizedBox(height: 18),
                      footer,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Text field with an optional show/hide toggle for passwords.
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? helperText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.helperText,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: widget.isPassword && _hidden,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      autocorrect: false,
      enableSuggestions: !widget.isPassword,
      style: const TextStyle(fontSize: 14.5),
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        helperMaxLines: 2,
        prefixIcon: Icon(
          widget.icon,
          size: 20,
          color: CineAITheme.textSecondary,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _hidden ? 'Show password' : 'Hide password',
                icon: Icon(
                  _hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: CineAITheme.textSecondary,
                ),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null,
      ),
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  final String message;

  const AuthErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CineAITheme.danger.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(CineAITheme.buttonRadius),
        border: Border.all(color: CineAITheme.danger.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: CineAITheme.danger,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}