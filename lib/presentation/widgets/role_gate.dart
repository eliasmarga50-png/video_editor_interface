import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../domain/value_objects/user_role.dart';

/// Shows [child] only when the signed-in user has at least [minRole].
/// UI gating only — the server must still enforce the same rule.
class RoleGate extends ConsumerWidget {
  final UserRole minRole;
  final Widget child;
  final Widget fallback;

  const RoleGate({
    super.key,
    required this.minRole,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    return (user != null && user.hasRole(minRole)) ? child : fallback;
  }
}