enum UserRole {
  user,
  pro,
  admin;

  static UserRole parse(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'pro':
        return UserRole.pro;
      default:
        return UserRole.user;
    }
  }

  /// Roles are ordered: user < pro < admin.
  bool atLeast(UserRole minimum) => index >= minimum.index;

  String get label {
    switch (this) {
      case UserRole.user:
        return 'Free';
      case UserRole.pro:
        return 'Pro';
      case UserRole.admin:
        return 'Admin';
    }
  }
}