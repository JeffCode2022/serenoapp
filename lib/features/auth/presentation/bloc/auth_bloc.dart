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
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      final dni = session.user.email?.split('@').first ?? 'Desconocido';
      
      try {
        final profileData = await supabase
            .from('profiles')
            .select()
            .eq('id', session.user.id)
            .maybeSingle();

        if (profileData != null) {
          emit(AuthAuthenticated(
            dni: dni,
            fullName: profileData['full_name'] ?? 'Usuario',
            avatarUrl: profileData['avatar_url'],
            role: profileData['role'] ?? 'SERENO',
            sector: profileData['sector'] ?? 'Sector 03',
          ));
        } else {
          emit(AuthAuthenticated(
            dni: dni,
            fullName: 'Usuario',
            role: 'SERENO',
            sector: 'Sector 03',
          ));
        }
      } catch (e) {
        // Fallback offline
        emit(AuthAuthenticated(
          dni: dni,
          fullName: 'Usuario (Offline)',
          role: 'SERENO',
          sector: 'Sector 03',
        ));
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final syntheticEmail = '${event.dni}@surquillo.pe';
      
      final response = await supabase.auth.signInWithPassword(
        email: syntheticEmail,
        password: event.pin,
      );

      if (response.user != null) {
        final profileData = await supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (profileData != null) {
          emit(AuthAuthenticated(
            dni: event.dni,
            fullName: profileData['full_name'] ?? 'Usuario',
            avatarUrl: profileData['avatar_url'],
            role: profileData['role'] ?? 'SERENO',
            sector: profileData['sector'] ?? 'Sector 03',
          ));
        } else {
          emit(AuthAuthenticated(
            dni: event.dni,
            fullName: 'Usuario',
            role: 'SERENO',
            sector: 'Sector 03',
          ));
        }
      } else {
        emit(const AuthError(message: 'DNI o PIN incorrecto'));
      }
    } catch (e) {
      if (e.toString().contains('Invalid login credentials')) {
        emit(const AuthError(message: 'DNI o PIN incorrecto. Intente de nuevo.'));
      } else {
        emit(AuthError(message: 'Error de conexión: ${e.toString()}'));
      }
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await supabase.auth.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onUpdateProfileRequested(UpdateProfileRequested event, Emitter<AuthState> emit) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      try {
        final userId = supabase.auth.currentUser?.id;
        if (userId != null) {
          final updates = {
            'full_name': event.fullName,
            if (event.avatarUrl != null) 'avatar_url': event.avatarUrl,
          };
          
          await supabase.from('profiles').update(updates).eq('id', userId);

          emit(AuthAuthenticated(
            dni: currentState.dni,
            fullName: event.fullName,
            avatarUrl: event.avatarUrl ?? currentState.avatarUrl,
            role: currentState.role,
            sector: currentState.sector,
          ));
        }
      } catch (e) {
        emit(AuthError(message: 'No se pudo actualizar el perfil: ${e.toString()}'));
        // Restore state to avoid blanking out the UI
        emit(currentState);
      }
    }
  }
}
