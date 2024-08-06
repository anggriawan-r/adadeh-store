import 'package:adadeh_store/data/models/user_model.dart';
import 'package:adadeh_store/data/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _authRepository = AuthRepository();

  Future<UserModel?> getUserProfile() async {
    try {
      final User? user = _authRepository.getCurrentUser();
      final doc =
          await _firebaseFirestore.collection('users').doc(user!.uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc, null);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
