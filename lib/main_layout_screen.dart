import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../features/muro/presentation/muro_screen.dart';

class MainLayoutScreen extends StatefulWidget {
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
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // El botón de reportar podría abrir un modal o ir a la ruta directo
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
  }
}
