import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient supabase;

  AuthBloc({required this.supabase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final session = supabase.auth.currentSession;
    if (session != null) {
      // Extraer el DNI del correo sintético (dni@surquillo.pe)
      final dni = session.user.email?.split('@').first ?? 'Desconocido';
      emit(AuthAuthenticated(dni: dni));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Mapeo sintético de DNI a Email para "Fricción Cero"
      final syntheticEmail = '${event.dni}@surquillo.pe';
      
      print('=== DEBUG LOGIN ===');
      print('Intentando login con Email exacto: "$syntheticEmail"');
      print('PIN exacto: "${event.pin}"');
      print('===================');

      final response = await supabase.auth.signInWithPassword(
        email: syntheticEmail,
        password: event.pin,
      );

      if (response.user != null) {
        emit(AuthAuthenticated(dni: event.dni));
      } else {
        emit(const AuthError(message: 'DNI o PIN incorrecto'));
      }
    } catch (e) {
      // Si el error es de credenciales, mostrar mensaje amigable
      if (e.toString().contains('Invalid login credentials')) {
         emit(const AuthError(message: 'DNI o PIN incorrecto. Intente de nuevo.'));
      } else {
         emit(AuthError(message: 'Error de conexión: \${e.toString()}'));
      }
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await supabase.auth.signOut();
    emit(AuthUnauthenticated());
  }
}
