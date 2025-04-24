class Organizer {
  final int id;
  final int userId;

  Organizer({required this.id, required this.userId});

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['organizer_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizer_id': id,
      'user_id': userId,
    };
  }
}
