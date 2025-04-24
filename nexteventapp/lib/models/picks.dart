class Pick {
  final int attendeeId;
  final int itineraryId;

  Pick({required this.attendeeId, required this.itineraryId});

  factory Pick.fromJson(Map<String, dynamic> json) {
    return Pick(
      attendeeId: json['attendee_id'] ?? 0,
      itineraryId: json['itinerary_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendee_id': attendeeId,
      'itinerary_id': itineraryId,
    };
  }
}
