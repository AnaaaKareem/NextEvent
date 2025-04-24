class Feedback {
  final int id;
  final int itineraryId;
  final int attendeeId;
  final int rating;
  final String? comment;

  Feedback({
    required this.id,
    required this.itineraryId,
    required this.attendeeId,
    required this.rating,
    this.comment,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['feedback_id'] ?? 0,
      itineraryId: json['itinerary_id'] ?? 0,
      attendeeId: json['attendee_id'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': id,
      'itinerary_id': itineraryId,
      'attendee_id': attendeeId,
      'rating': rating,
      'comment': comment,
    };
  }
}
