import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int price;
  final DocumentReference categoryRef;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.categoryRef,
  });

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ProductModel(
      id: snapshot.id,
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      price: data?['price'] ?? 0,
      categoryRef: data?['categoryRef'] as DocumentReference,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'categoryRef': categoryRef,
    };
  }
}
