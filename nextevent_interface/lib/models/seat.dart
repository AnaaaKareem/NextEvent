class Seat {
  // Set attributes
  final String column;
  final int row;
  final int venueId;
  final bool availability;

  // Return attributes
  Seat({
    required this.column,
    required this.row,
    required this.venueId,
    required this.availability,
  });

  // Parse Seat JSON data
  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      column: json['seat_column'] ?? '',
      row: json['seat_row'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      availability: json['availability'] ?? false,
    );
  }

  // Convert Seat data to JSON
  Map<String, dynamic> toJson() {
    return {
      'seat_column': column,
      'seat_row': row,
      'venue_id': venueId,
      'availability': availability,
    };
  }
}