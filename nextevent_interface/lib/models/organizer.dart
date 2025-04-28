class Organizer {
  // Set attributes
  final int id;
  final int userId;

  // Return attributes
  Organizer({required this.id, required this.userId});

  // Parse Organizer JSON data
  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['organizer_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  // Convert Organizer data to JSON
  Map<String, dynamic> toJson() {
    return {
      'organizer_id': id,
      'user_id': userId,
    };
  }
}