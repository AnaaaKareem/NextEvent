class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  // ✅ Factory Constructor to Handle Missing Fields Safely
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['userId'] ?? 0) as int, // Ensure integer
      name: (json['name'] ?? "").toString(), // Ensure string
      email: (json['email'] ?? "").toString(),
      role: (json['role'] ?? "user").toString(),
      token: (json['token'] ?? "").toString(),
    );
  }

  // ✅ Convert User Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "userId": id,
      "name": name,
      "email": email,
      "role": role,
      "token": token,
    };
  }

  // ✅ Allow Modifications with Copy Method
  User copyWith({int? id, String? name, String? email, String? role, String? token}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}