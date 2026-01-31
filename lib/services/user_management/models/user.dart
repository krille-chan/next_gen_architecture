class User {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final Uri? avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, Object?> json) => User(
    id: json['id'] as int,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String,
    email: json['email'] as String?,
    avatar: json['avatar'] is String
        ? Uri.tryParse(json['avatar'] as String)
        : null,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'avatar': avatar?.toString(),
  };
}
