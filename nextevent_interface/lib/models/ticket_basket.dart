class TicketBasket {
  // Set attributes
  final int ticketId;
  final int basketId;
  final String timeAdded;

  // Return attributes
  TicketBasket({
    required this.ticketId,
    required this.basketId,
    required this.timeAdded,
  });

  // Parse TicketBasket JSON data
  factory TicketBasket.fromJson(Map<String, dynamic> json) {
    return TicketBasket(
      ticketId: json['ticket_id'] ?? 0,
      basketId: json['basket_id'] ?? 0,
      timeAdded: json['time_added'] ?? '',
    );
  }

  // Convert TicketBasket data to JSON
  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'basket_id': basketId,
      'time_added': timeAdded,
    };
  }
}