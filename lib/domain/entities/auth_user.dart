import 'package:equatable/equatable.dart';
import '../value_objects/user_role.dart';

class AuthUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'].toString(),
      name: (json['name'] ?? '') as String,
      email: json['email'] as String,
      role: UserRole.parse(json['role'] as String?),
    );
  }

  bool hasRole(UserRole minimum) => role.atLeast(minimum);

  @override
  List<Object?> get props => [id, name, email, role];
}