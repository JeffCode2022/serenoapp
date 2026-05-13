import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class MuroScreen extends StatelessWidget {
  const MuroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 1,
        shadowColor: Colors.black12,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Iconsax.user, size: 20, color: Colors.black),
            ),
            const SizedBox(width: 12),
            const Text('Hola, Jefferson', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // Mock posts
        itemBuilder: (context, index) {
          return const PostCard();
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Card(
        // Utiliza el CardTheme global
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (Avatar, Nombre, Tiempo)
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    child: Icon(Iconsax.shield_tick, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Genaro Rojas Buleje', style: theme.textTheme.labelLarge),
                        Text('Supervisor Zona 3 • Hace 10 min', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.more, color: Colors.grey),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 12),
              
              // CONTENIDO
              Text(
                'Unidad Águila 4 aproximándose a Av. Aviación cdra 46 por reporte de vehículos mal estacionados. Solicito apoyo de grúa en la zona.',
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 16),
              
              const Divider(color: Color(0xFF2C2C2C), height: 1),
              
              // ACCIONES (Like, Comment, Share)
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      icon: Icon(Iconsax.like_1, size: 18, color: theme.colorScheme.secondary),
                      label: FittedBox(child: Text('Me gusta', style: TextStyle(color: theme.colorScheme.secondary, fontSize: 13))),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      icon: const Icon(Iconsax.message, size: 18, color: Colors.grey),
                      label: const FittedBox(child: Text('Comentar', style: TextStyle(color: Colors.grey, fontSize: 13))),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      icon: const Icon(Iconsax.send_2, size: 18, color: Colors.grey),
                      label: const FittedBox(child: Text('Compartir', style: TextStyle(color: Colors.grey, fontSize: 13))),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
