class Basket {
  // Set attributes
  final int id;
  final int attendeeId;

  // Return attributes
  Basket({required this.id, required this.attendeeId});

  // Parse Basket JSON data
  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['basket_id'] ?? 0,
      attendeeId: json['attendee_id'] ?? 0,
    );
  }

  // Convert Basket data to JSON
  Map<String, dynamic> toJson() {
    return {
      'basket_id': id,
      'attendee_id': attendeeId,
    };
  }
}