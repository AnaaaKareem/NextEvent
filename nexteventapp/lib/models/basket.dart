class Basket {
  final int id;
  final int attendeeId;

  Basket({required this.id, required this.attendeeId});

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['basket_id'] ?? 0,
      attendeeId: json['attendee_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basket_id': id,
      'attendee_id': attendeeId,
    };
  }
}
