import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String name;

  CategoryModel({
    required this.name,
  });

  factory CategoryModel.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return CategoryModel(
      name: data?['name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }
}
