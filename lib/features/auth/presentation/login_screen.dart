import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  void _login() {
    final dni = _dniController.text.trim();
    final pin = _pinController.text.trim();
    if (dni.isNotEmpty && pin.length >= 4) {
      context.read<AuthBloc>().add(LoginRequested(
            dni: dni,
            pin: pin,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      // Logo minimalista
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Iconsax.shield_tick, size: 30, color: theme.colorScheme.onPrimary),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Red Operativa',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa para continuar',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 48),
                      TextField(
                        controller: _dniController,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        style: theme.textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'Número de DNI',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        style: theme.textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'PIN de Seguridad',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                                child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          return ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            child: const Text('Ingresar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
