class CheckInStaff {
  // Set attributes
  final int id;
  final int userId;

  // Return attributes
  CheckInStaff({required this.id, required this.userId});

  // Parse CheckInStaff JSON data
  factory CheckInStaff.fromJson(Map<String, dynamic> json) {
    return CheckInStaff(
      id: json['staff_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  // Convert CheckInStaff data to JSON
  Map<String, dynamic> toJson() {
    return {
      'staff_id': id,
      'user_id': userId,
    };
  }
}