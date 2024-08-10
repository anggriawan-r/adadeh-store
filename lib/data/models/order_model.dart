class OrderModel {
  final String id;
  final double adminFee;
  final double shippingCost;
  final String status;
  final double totalAmount;
  final double totalPrice;
  final String userId;
  final String orderDate;
  final String paymentMethod;
  final List<dynamic> products;

  OrderModel({
    required this.id,
    required this.adminFee,
    required this.shippingCost,
    required this.status,
    required this.totalAmount,
    required this.totalPrice,
    required this.userId,
    required this.orderDate,
    required this.paymentMethod,
    required this.products,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> firestore) {
    return OrderModel(
      id: firestore['id'] ?? '',
      adminFee: (firestore['adminFee'] as num).toDouble(),
      shippingCost: (firestore['shippingCost'] as num).toDouble(),
      status: firestore['status'] ?? '',
      totalAmount: (firestore['totalAmount'] as num).toDouble(),
      totalPrice: (firestore['totalPrice'] as num).toDouble(),
      userId: firestore['userId'] ?? '',
      orderDate: firestore['orderDate'] ?? DateTime.now(),
      paymentMethod: firestore['paymentMethod'] ?? '',
      products: firestore['products'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'adminFee': adminFee,
      'shippingCost': shippingCost,
      'status': status,
      'totalAmount': totalAmount,
      'totalPrice': totalPrice,
      'userId': userId,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'products': products,
    };
  }
}
