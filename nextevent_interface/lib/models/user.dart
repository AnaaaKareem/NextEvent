class User {
  // Set attributes
  final int id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String userType;
  final String token;

  // Return attributes
  User({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phoneNumber,
    required this.userType,
    required this.token,
  });

  // Create role alias for user type
  String get role => userType;

  // Parse User JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'],
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phone_number'],
      userType: json['user_type'] ?? '',
      token: json['token'] ?? '',
    );
  }

  // Convert User data to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'user_type': userType,
      'token': token,
    };
  }

  // Create attribute copies with optional overrides
  User copyWith({
    int? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? password,
    String? phoneNumber,
    String? userType,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      token: token ?? this.token,
    );
  }
}
