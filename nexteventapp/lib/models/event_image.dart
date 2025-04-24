class EventImage {
  final int id;
  final int eventId;
  final String image;

  EventImage({required this.id, required this.eventId, required this.image});

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['image_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_id': id,
      'event_id': eventId,
      'image': image,
    };
  }
}
