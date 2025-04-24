class ManageTicket {
  final int organizerId;
  final int eventId;
  final int ticketId;

  ManageTicket({
    required this.organizerId,
    required this.eventId,
    required this.ticketId,
  });

  factory ManageTicket.fromJson(Map<String, dynamic> json) {
    return ManageTicket(
      organizerId: json['organizer_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      ticketId: json['ticket_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizer_id': organizerId,
      'event_id': eventId,
      'ticket_id': ticketId,
    };
  }
}
