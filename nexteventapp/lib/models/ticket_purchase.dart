class TicketPurchase {
  final int attendeeId;
  final int orderId;
  final int ticketId;
  final String qrCodeValue;
  final String ticketStatus;

  TicketPurchase({
    required this.attendeeId,
    required this.orderId,
    required this.ticketId,
    required this.qrCodeValue,
    required this.ticketStatus,
  });

  factory TicketPurchase.fromJson(Map<String, dynamic> json) {
    return TicketPurchase(
      attendeeId: json['attendee_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      ticketId: json['ticket_id'] ?? 0,
      qrCodeValue: json['qr_code_value'] ?? '',
      ticketStatus: json['ticket_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendee_id': attendeeId,
      'order_id': orderId,
      'ticket_id': ticketId,
      'qr_code_value': qrCodeValue,
      'ticket_status': ticketStatus,
    };
  }
}
