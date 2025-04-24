class TicketBasket {
  final int ticketId;
  final int basketId;
  final String timeAdded;

  TicketBasket({
    required this.ticketId,
    required this.basketId,
    required this.timeAdded,
  });

  factory TicketBasket.fromJson(Map<String, dynamic> json) {
    return TicketBasket(
      ticketId: json['ticket_id'] ?? 0,
      basketId: json['basket_id'] ?? 0,
      timeAdded: json['time_added'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'basket_id': basketId,
      'time_added': timeAdded,
    };
  }
}