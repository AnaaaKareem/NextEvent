class Seat {
  final String column;
  final int row;
  final int venueId;
  final bool availability;

  Seat({
    required this.column,
    required this.row,
    required this.venueId,
    required this.availability,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      column: json['seat_column']?.toString() ?? '',
      row: json['seat_row'] is int ? json['seat_row'] : int.tryParse(json['seat_row'].toString()) ?? 0,
      venueId: json['venue_id'] is int ? json['venue_id'] : int.tryParse(json['venue_id'].toString()) ?? 0,
      availability: json['availability'] is bool
          ? json['availability']
          : json['availability'].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seat_column': column,
      'seat_row': row,
      'venue_id': venueId,
      'availability': availability,
    };
  }

  // Optional: helpful when you want to update one property (like availability)
  Seat copyWith({
    String? column,
    int? row,
    int? venueId,
    bool? availability,
  }) {
    return Seat(
      column: column ?? this.column,
      row: row ?? this.row,
      venueId: venueId ?? this.venueId,
      availability: availability ?? this.availability,
    );
  }
}
