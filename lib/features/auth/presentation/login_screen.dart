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
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // BACKGROUND DYNAMICS
            Positioned(
              top: -100,
              right: -100,
              child: _CircleBlur(color: theme.colorScheme.primary.withOpacity(0.15), size: 300),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _CircleBlur(color: theme.colorScheme.secondary.withOpacity(0.1), size: 250),
            ),
            
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // LOGO & HEADER
                      const _YouthfulHeader(),
                      const SizedBox(height: 48),
                      
                      // FORM
                      Text(
                        'DNI',
                        style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dniController,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: const InputDecoration(
                          hintText: 'Ingresa tu DNI',
                          counterText: '',
                          prefixIcon: Icon(Iconsax.user, size: 20),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        'PIN DE SEGURIDAD',
                        style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          hintText: '••••••',
                          counterText: '',
                          prefixIcon: Icon(Iconsax.key, size: 20),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // LOGIN BUTTON
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? theme.colorScheme.primary : Colors.black,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                  )
                                : const Text('Acceder a la Red'),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      Text(
                        'Red Operativa Serenazgo Surquillo',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YouthfulHeader extends StatelessWidget {
  const _YouthfulHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Iconsax.shield_security, size: 48, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 24),
        Text(
          'SerenoApp',
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 36),
        ),
        const SizedBox(height: 8),
        Text(
          'Vigilancia inteligente para la nueva generación',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _CircleBlur extends StatelessWidget {
  final Color color;
  final double size;

  const _CircleBlur({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 100,
              spreadRadius: 50,
            ),
          ],
        ),
      ),
    );
  }
}
