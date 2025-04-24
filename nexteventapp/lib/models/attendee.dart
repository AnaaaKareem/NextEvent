class Attendee {
  final int id;
  final int userId;
  final String dateOfBirth;
  final String address;

  Attendee({
    required this.id,
    required this.userId,
    required this.dateOfBirth,
    required this.address,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['attendee_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      dateOfBirth: json['date_of_birth'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendee_id': id,
      'user_id': userId,
      'date_of_birth': dateOfBirth,
      'address': address,
    };
  }
}
