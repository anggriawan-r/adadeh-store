import 'package:adadeh_store/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String address,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);

        final UserModel userData = UserModel(
          name: name,
          email: email,
          phone: phone,
          role: 'user',
          address: address,
          photoUrl: '',
        );

        await _firebaseFirestore.collection('users').doc(user.uid).set(
              userData.toFirestore(),
            );
      }

      _firebaseAuth.signOut();

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        return user;
      } else {
        throw Exception('Email not verified');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }
}
