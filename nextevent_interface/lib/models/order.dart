class Order {
  // Set attributes
  final int id;
  final int paymentId;
  final String orderDate;
  final String orderTime;

  // Return attributes
  Order({
    required this.id,
    required this.paymentId,
    required this.orderDate,
    required this.orderTime,
  });

  // Parse Order JSON data
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'] ?? 0,
      paymentId: json['payment_id'] ?? 0,
      orderDate: json['order_date'] ?? '',
      orderTime: json['order_time'] ?? '',
    );
  }

  // Convert Order data to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': id,
      'payment_id': paymentId,
      'order_date': orderDate,
      'order_time': orderTime,
    };
  }
}