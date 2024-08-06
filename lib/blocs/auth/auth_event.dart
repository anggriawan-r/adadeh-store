part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLoggedOut extends AuthEvent {}

class AuthRegistered extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;

  const AuthRegistered({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, phone, email, password];
}
