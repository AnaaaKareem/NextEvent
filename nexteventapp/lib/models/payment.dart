class Payment {
  final int id;
  final int attendeeId;
  final String paymentMethod;
  final double amount;

  Payment({
    required this.id,
    required this.attendeeId,
    required this.paymentMethod,
    required this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['payment_id'] ?? 0,
      attendeeId: json['attendee_id'] ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': id,
      'attendee_id': attendeeId,
      'payment_method': paymentMethod,
      'amount': amount,
    };
  }
}
