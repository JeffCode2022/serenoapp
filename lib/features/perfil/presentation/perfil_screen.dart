import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';

/// Pantalla de Perfil de Sereno con Dashboard Ejecutivo de KPI.
/// Muestra estadísticas de patrullaje, reportes oficiales y turnos activos.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String dni = '---';
        if (state is AuthAuthenticated) {
          dni = state.dni;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Cabecera con Avatar y Datos del Sereno
              _buildProfileHeader(theme, dni),
              const SizedBox(height: 24),

              // 2. Estado de Turno Pulsante
              _buildShiftStatusCard(theme),
              const SizedBox(height: 24),

              // 3. Grid de KPIs de Desempeño
              Text(
                'KPIs de Desempeño Mensual',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildKpiGrid(theme),
              const SizedBox(height: 24),

              // 4. Panel de Acciones y Ajustes
              Text(
                'Opciones del Dispositivo',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildActionList(context, theme),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(ThemeData theme, String dni) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F2FF).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: const AssetImage('assets/images/default_user.png'),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0F172A), width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 12),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Chunga Zapata Jefferson',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Iconsax.verify5, size: 18, color: Color(0xFF00F2FF)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Patrullero Motorizado • Sector 03',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'DNI: $dni',
                    style: const TextStyle(
                      color: Color(0xFF00F2FF),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftStatusCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF334155).withOpacity(0.5)),
      ),
      child: const Row(
        children: [
          _PulsingActiveBadge(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turno Activo • Patrullaje de Noche',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  'Fin de turno: 06:00 AM • Unidad M-09',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildKpiCard(
          theme,
          Iconsax.routing,
          '148.5 km',
          'Patrullado Total',
          const Color(0xFF00F2FF),
        ),
        _buildKpiCard(
          theme,
          Iconsax.document_text,
          '42',
          'Reportes Enviados',
          Colors.purple.shade300,
        ),
        _buildKpiCard(
          theme,
          Iconsax.danger,
          '15',
          'Alertas SOS Atendidas',
          Colors.red,
        ),
        _buildKpiCard(
          theme,
          Iconsax.star,
          '4.92 / 5.0',
          'Calificación Jefe',
          Colors.orange.shade400,
        ),
      ],
    );
  }

  Widget _buildKpiCard(ThemeData theme, IconData icon, String value, String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 20),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionList(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          _buildActionTile(theme, Iconsax.setting, 'Preferencias de Sector', 'Configura tu zona de patrullaje principal'),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          _buildActionTile(theme, Iconsax.shield_security, 'Seguridad y PIN', 'Actualizar tu clave de acceso'),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          _buildActionTile(theme, Iconsax.info_circle, 'Soporte y Ayuda', 'Contactar con la Jefatura'),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          _buildActionTile(
            theme,
            Iconsax.logout,
            'Cerrar Sesión',
            'Desvincular esta cuenta del dispositivo',
            color: Colors.redAccent,
            onTap: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Icon(icon, color: color ?? const Color(0xFF00F2FF), size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[600], size: 20),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPONENTE DE BADGE PULSANTE DE ESTADO
// ─────────────────────────────────────────────────────────────
class _PulsingActiveBadge extends StatefulWidget {
  const _PulsingActiveBadge();

  @override
  State<_PulsingActiveBadge> createState() => _PulsingActiveBadgeState();
}

class _PulsingActiveBadgeState extends State<_PulsingActiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24 * (1 + _pulseCtrl.value * 0.4),
              height: 24 * (1 + _pulseCtrl.value * 0.4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3 * (1 - _pulseCtrl.value)),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }
}
