part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String dni;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String sector;
  
  const AuthAuthenticated({
    required this.dni,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.sector,
  });
  
  @override
  List<Object?> get props => [dni, fullName, avatarUrl, role, sector];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
