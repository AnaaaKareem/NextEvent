class Itinerary {
  // Set attributes
  final int id;
  final int eventId;
  final String sessionName;
  final String sessionDescription;
  final String guest;
  final String date;
  final String startTime;
  final String endTime;

  // Return attributes
  Itinerary({
    required this.id,
    required this.eventId,
    required this.sessionName,
    required this.sessionDescription,
    required this.guest,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // Parse Itinerary JSON data
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['itinerary_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      sessionName: json['session_name'] ?? '',
      sessionDescription: json['session_description'] ?? '',
      guest: json['guest'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }

  // Convert Itinerary data to JSON
  Map<String, dynamic> toJson() {
    return {
      'itinerary_id': id,
      'event_id': eventId,
      'session_name': sessionName,
      'session_description': sessionDescription,
      'guest': guest,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}