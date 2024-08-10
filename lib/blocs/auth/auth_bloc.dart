import 'package:adadeh_store/data/models/user_model.dart';
import 'package:adadeh_store/data/repositories/auth_repository.dart';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>(
      (event, emit) async {
        try {
          final user = _authRepository.getCurrentUser();
          if (user != null) {
            final doc =
                await _firestore.collection('users').doc(user.uid).get();

            final profile = UserModel.fromFirestore(doc, null);

            emit(AuthAuthenticated(user: user, profile: profile));
          } else {
            emit(AuthUnauthenticated());
          }
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );

    on<AuthLoggedIn>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final user = await _authRepository.login(
            email: event.email,
            password: event.password,
          );

          if (user == null) {
            throw Exception('User not found');
          }

          final doc = await _firestore.collection('users').doc(user.uid).get();

          final profile = UserModel.fromFirestore(doc, null);

          emit(AuthAuthenticated(user: user, profile: profile));
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );

    on<AuthLoggedOut>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authRepository.logout();
          emit(AuthUnauthenticated());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(const AuthFailure(error: 'No user found for that email.'));
          } else if (e.code == 'wrong-password') {
            emit(const AuthFailure(error: 'Wrong email or password.'));
          }
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );

    on<AuthRegistered>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authRepository.register(
            name: event.name,
            phone: event.phone,
            email: event.email,
            password: event.password,
            address: event.address,
          );

          emit(AuthRegisterSuccess());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            emit(
              const AuthFailure(
                error: 'The password provided is too weak.',
              ),
            );
          } else if (e.code == 'email-already-in-use') {
            emit(
              const AuthFailure(
                error: 'The account already exists for that email.',
              ),
            );
          }
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );

    on<VerifyEmail>((event, emit) async {
      try {
        await _authRepository.verifyEmail();
        add(AuthStarted());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
