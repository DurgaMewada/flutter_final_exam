class UsersModal {
  String? name, email, phone;

  UsersModal({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UsersModal.fromMap(Map m1) {
    return UsersModal(
      name: m1['name'],
      email: m1['email'],
      phone: m1['phone'],
    );
  }

  Map<String, String?> toMap(UsersModal user) {
    return {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
    };
  }
}
