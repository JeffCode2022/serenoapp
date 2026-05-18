part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String dni;
  final String pin;

  const LoginRequested({required this.dni, required this.pin});
  
  @override
  List<Object?> get props => [dni, pin];
}

class LogoutRequested extends AuthEvent {}

class UpdateProfileRequested extends AuthEvent {
  final String fullName;
  final String? avatarUrl;

  const UpdateProfileRequested({
    required this.fullName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [fullName, avatarUrl];
}
