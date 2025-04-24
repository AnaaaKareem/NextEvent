class Ticket {
  final int id;
  final int venueId;
  final String seatColumn;
  final int seatRow;
  final double price;
  final double discount;
  final String status;

  Ticket({
    required this.id,
    required this.venueId,
    required this.seatColumn,
    required this.seatRow,
    required this.price,
    required this.discount,
    required this.status,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['ticket_id'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      seatColumn: json['seat_column'] ?? '',
      seatRow: json['seat_row'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': id,
      'venue_id': venueId,
      'seat_column': seatColumn,
      'seat_row': seatRow,
      'price': price,
      'discount': discount,
      'status': status,
    };
  }
}
