class Event {
  // Set attributes
  final int id;
  final int organizerId;
  final String name;
  final String type;
  final String description;
  final String location;
  final String status;
  final double budget;
  final String startDate;
  final String endDate;

  // Return attributes
  Event({
    required this.id,
    required this.organizerId,
    required this.name,
    required this.type,
    required this.description,
    required this.location,
    required this.status,
    required this.budget,
    required this.startDate,
    required this.endDate,
  });

  // create title and dat aliases for event name and start date
  String get title => name;
  String get date => startDate;

  // Parse Event JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['event_id'] ?? 0,
      organizerId: json['organizer_id'] ?? 0,
      name: json['event_name'] ?? '',
      type: json['event_type'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  // Convert Event data to JSON
  Map<String, dynamic> toJson() {
    return {
      'event_id': id,
      'organizer_id': organizerId,
      'event_name': name,
      'event_type': type,
      'description': description,
      'location': location,
      'status': status,
      'budget': budget,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
