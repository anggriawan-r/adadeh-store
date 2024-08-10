part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final UserModel profile;

  const AuthAuthenticated({required this.user, required this.profile});

  @override
  List<Object> get props => [user, profile];
}

class AuthUnauthenticated extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthEmailVerified extends AuthState {}
