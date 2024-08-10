// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String address;
  final String photoUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    required this.photoUrl,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      name: data?['name'] ?? '',
      email: data?['email'] ?? '',
      phone: data?['phone'] ?? '',
      role: data?['role'] ?? '',
      address: data?['address'] ?? '',
      photoUrl: data?['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'photoUrl': photoUrl,
    };
  }
}
