class Pick {
  // Set attributes
  final int attendeeId;
  final int itineraryId;

  // Return attributes
  Pick({required this.attendeeId, required this.itineraryId});

  // Parse Pick JSON data
  factory Pick.fromJson(Map<String, dynamic> json) {
    return Pick(
      attendeeId: json['attendee_id'] ?? 0,
      itineraryId: json['itinerary_id'] ?? 0,
    );
  }

  // Convert Pick data to JSON
  Map<String, dynamic> toJson() {
    return {
      'attendee_id': attendeeId,
      'itinerary_id': itineraryId,
    };
  }
}