class CheckInStaff {
  final int id;
  final int userId;

  CheckInStaff({required this.id, required this.userId});

  factory CheckInStaff.fromJson(Map<String, dynamic> json) {
    return CheckInStaff(
      id: json['staff_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_id': id,
      'user_id': userId,
    };
  }
}