class ManageTicket {
  // Set attributes
  final int organizerId;
  final int eventId;
  final int ticketId;

  // Return attributes
  ManageTicket({
    required this.organizerId,
    required this.eventId,
    required this.ticketId,
  });

  // Parse ManageTicket JSON data
  factory ManageTicket.fromJson(Map<String, dynamic> json) {
    return ManageTicket(
      organizerId: json['organizer_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      ticketId: json['ticket_id'] ?? 0,
    );
  }

  // Convert ManageTicket data to JSON
  Map<String, dynamic> toJson() {
    return {
      'organizer_id': organizerId,
      'event_id': eventId,
      'ticket_id': ticketId,
    };
  }
}