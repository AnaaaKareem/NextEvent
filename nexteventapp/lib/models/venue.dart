class Venue {
  final int id;
  final int eventId;
  final String location;

  Venue({
    required this.id,
    required this.eventId,
    required this.location,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['venue_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      location: json['venue_location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'venue_id': id,
      'event_id': eventId,
      'venue_location': location,
    };
  }
}