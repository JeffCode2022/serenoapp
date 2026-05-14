import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/muro/presentation/muro_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  static const Color primaryColor = Color(0xFF00F2FF);
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MuroScreen(),
    const Center(child: Text('Radar (Mapa)')), // Placeholder
    const Center(child: Text('Reportar')), // Placeholder
    const Center(child: Text('Perfil')), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userDni = 'Usuario';
        if (state is AuthAuthenticated) {
          userDni = state.dni;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _currentIndex == 0 ? 'SerenoApp' : 
              _currentIndex == 1 ? 'Radar' :
              _currentIndex == 2 ? 'Reportar' : 'Perfil',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'user-avatar',
                child: CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/default_user.png'),
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            actions: [
              if (_currentIndex == 0)
                IconButton(
                  icon: const Icon(Iconsax.add_circle, color: MainLayoutScreen.primaryColor),
                  onPressed: () {
                    // Llamamos a un método estático o usamos un GlobalKey si es necesario, 
                    // pero por simplicidad, definiremos el modal aquí o en el MuroScreen.
                    MuroScreen.showCreatePostModal(context);
                  },
                ),
              IconButton(
                icon: const Icon(Iconsax.notification),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Iconsax.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  context.go('/login');
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Lógica de SOS
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡ALERTA SOS ENVIADA!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: const Icon(Iconsax.danger, size: 24),
            label: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 2) {
                context.push('/formulario');
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.colorScheme.background,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'Muro',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.map),
                label: 'Radar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.add_square),
                label: 'Reportar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}
