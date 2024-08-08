import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String id;
  final String userId;
  final List<CartItem> products;
  final DateTime date;

  CartModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.date,
  });

  factory CartModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CartModel(
      id: snapshot.id,
      userId: data?['userId'] ?? '',
      products: (data?['products'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      date: (data?['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'products': products.map((item) => item.toMap()).toList(),
      'date': Timestamp.fromDate(date),
    };
  }
}

class CartItem {
  final String productId;
  final int quantity;
  bool isChecked;

  CartItem({
    required this.productId,
    required this.quantity,
    this.isChecked = false,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
      isChecked: map['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'isChecked': isChecked,
    };
  }
}
