import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../auth/presentation/bloc/auth_bloc.dart';

/// Pantalla de Perfil de Sereno con Dashboard Ejecutivo de KPI.
/// Muestra estadísticas de patrullaje, reportes oficiales y turnos activos.
/// Soporta tema dinámico día/noche con efecto Liquid Glass adaptativo
/// y edición del perfil (Nombre, Apellidos y Foto) sincronizado en tiempo real con Supabase.
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _isNightShift = true; // Turno por defecto: Noche
  String _selectedServicePoint = 'Unidad Móvil M-09'; // Punto de servicio por defecto

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Tokens de Diseño Liquid Glass
    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.85);

    final cardBorderColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.8)
        : const Color(0xFFE2E8F0);

    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.grey[400]! : const Color(0xFF64748B);

    final shadowColor = isDark
        ? const Color(0xFF00F2FF).withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.04);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String dni = '---';
        String fullName = 'Sereno';
        String? avatarUrl;

        if (state is AuthAuthenticated) {
          dni = state.dni;
          fullName = state.fullName;
          avatarUrl = state.avatarUrl;
        }

        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.7, -0.6),
              radius: 1.2,
              colors: isDark
                  ? [
                      const Color(0xFF0F172A),
                      const Color(0xFF070B19),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF8FAFC),
                    ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cabecera con Avatar y Datos del Sereno (Interactiva para Edición)
                _buildProfileHeader(context, theme, dni, fullName, avatarUrl, isDark, cardBgColor, cardBorderColor, textColor, subTextColor, shadowColor),
                const SizedBox(height: 20),

                // 2. Estado de Turno Pulsante
                _buildShiftStatusCard(theme, isDark, cardBgColor, cardBorderColor, textColor, subTextColor),
                const SizedBox(height: 24),

                // 3. Grid de KPIs de Desempeño
                Text(
                  'KPIs de Desempeño Mensual',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                _buildKpiGrid(theme, isDark, cardBgColor, cardBorderColor, textColor, subTextColor),
                const SizedBox(height: 24),

                // 4. Panel de Acciones y Ajustes
                Text(
                  'Opciones del Dispositivo',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                _buildActionList(context, theme, isDark, cardBgColor, cardBorderColor, textColor, subTextColor, fullName, avatarUrl),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    ThemeData theme,
    String dni,
    String fullName,
    String? avatarUrl,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
    Color shadowColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showEditProfileModal(context, theme, fullName, avatarUrl),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl) as ImageProvider
                          : const AssetImage('assets/images/default_user.png'),
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? const Color(0xFF0F172A) : Colors.white, width: 2),
                      ),
                      child: Icon(
                        Iconsax.edit,
                        color: isDark ? Colors.black : Colors.white,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            fullName,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Iconsax.verify5, size: 18, color: Color(0xFF00F2FF)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patrullero Motorizado • Sector 03',
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155).withValues(alpha: 0.5)
                                  : const Color(0xFFCBD5E1),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            'DNI: $dni',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showEditProfileModal(context, theme, fullName, avatarUrl),
                          child: Text(
                            'Editar datos',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShiftStatusCard(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showShiftSelectionModal(context, theme, isDark, cardBorderColor, textColor),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.4)
                  : const Color(0xFFF1F5F9).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cardBorderColor, width: 1.2),
            ),
            child: Row(
              children: [
                _PulsingActiveBadge(isNight: _isNightShift),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isNightShift ? Iconsax.moon : Iconsax.sun_1,
                            size: 16,
                            color: _isNightShift ? const Color(0xFF00F2FF) : Colors.amber,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _isNightShift
                                  ? 'Turno Activo • Patrullaje de Noche'
                                  : 'Turno Activo • Patrullaje de Día',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isNightShift
                            ? 'Fin de turno: 06:00 AM • $_selectedServicePoint'
                            : 'Fin de turno: 06:00 PM • $_selectedServicePoint',
                        style: TextStyle(color: subTextColor, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 16,
                  color: textColor.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showShiftSelectionModal(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Color cardBorderColor,
    Color textColor,
  ) {
    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.85)
        : Colors.white.withValues(alpha: 0.9);

    final points = [
      'Unidad Móvil M-09',
      'Módulo Central MC-01',
      'Zona Turística ZT-04',
      'Punto Fijo Parques PF-02',
      'Caseta de Vigilancia CV-05',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: cardBorderColor, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Configurar Turno y Servicio',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Actualiza tu turno y punto de asignación actual',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sección de Turno
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Horario de Turno',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  setModalState(() {
                                    _isNightShift = false;
                                  });
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: !_isNightShift
                                        ? Colors.amber.withValues(alpha: 0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: !_isNightShift
                                          ? Colors.amber
                                          : cardBorderColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Iconsax.sun_1, color: Colors.amber, size: 24),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Turno Día',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '06:00 AM - 06:00 PM',
                                        style: TextStyle(
                                          color: isDark ? Colors.white54 : Colors.black54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  setModalState(() {
                                    _isNightShift = true;
                                  });
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: _isNightShift
                                        ? const Color(0xFF00F2FF).withValues(alpha: 0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isNightShift
                                          ? const Color(0xFF00F2FF)
                                          : cardBorderColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Iconsax.moon, color: Color(0xFF00F2FF), size: 24),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Turno Noche',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '06:00 PM - 06:00 AM',
                                        style: TextStyle(
                                          color: isDark ? Colors.white54 : Colors.black54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sección de Módulo de Servicio
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Módulo o Punto de Servicio',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: cardBorderColor, width: 1.2),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                value: _selectedServicePoint,
                                dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                                icon: Icon(Iconsax.arrow_down_1, color: textColor.withValues(alpha: 0.6), size: 20),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
                                items: points.map((p) {
                                  return DropdownMenuItem<String>(
                                    value: p,
                                    child: Text(p),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(() {
                                      _selectedServicePoint = val;
                                    });
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Botón de Confirmación
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Turno y Punto actualizados: ${_isNightShift ? "Turno Noche" : "Turno Día"} • $_selectedServicePoint',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: theme.colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              );
                            },
                            icon: const Icon(Iconsax.tick_circle),
                            label: const Text('Confirmar Cambios', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiGrid(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _buildKpiCard(
          theme,
          isDark,
          cardBgColor,
          cardBorderColor,
          textColor,
          subTextColor,
          Iconsax.routing,
          '148.5 km',
          'Patrullado Total',
          const Color(0xFF00F2FF),
        ),
        _buildKpiCard(
          theme,
          isDark,
          cardBgColor,
          cardBorderColor,
          textColor,
          subTextColor,
          Iconsax.document_text,
          '42',
          'Reportes Enviados',
          Colors.purple.shade300,
        ),
        _buildKpiCard(
          theme,
          isDark,
          cardBgColor,
          cardBorderColor,
          textColor,
          subTextColor,
          Iconsax.danger,
          '15',
          'Alertas SOS Atendidas',
          Colors.redAccent,
        ),
        _buildKpiCard(
          theme,
          isDark,
          cardBgColor,
          cardBorderColor,
          textColor,
          subTextColor,
          Iconsax.star,
          '4.92 / 5.0',
          'Calificación Jefe',
          Colors.orange.shade400,
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
    IconData icon,
    String value,
    String label,
    Color accentColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showKpiDetailModal(context, theme, isDark, cardBorderColor, textColor, label, value, icon, accentColor),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorderColor, width: 1.2),
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
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(color: subTextColor, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showKpiDetailModal(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Color cardBorderColor,
    Color textColor,
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.85)
        : Colors.white.withValues(alpha: 0.9);

    String detailTitle = '';
    String description = '';
    List<Map<String, String>> indicators = [];

    if (label.contains('Patrullado')) {
      detailTitle = 'Detalles de Patrullaje';
      description = 'Estadística acumulada de la distancia recorrida en patrullas a pie, motorizadas e integradas durante el mes actual.';
      indicators = [
        {'title': 'Distancia a Pie', 'value': '24.5 km'},
        {'title': 'Distancia Motorizada', 'value': '124.0 km'},
        {'title': 'Área de Cobertura', 'value': '94.2%'},
        {'title': 'Tiempo Activo en Ruta', 'value': '38.5 hrs'},
      ];
    } else if (label.contains('Reportes')) {
      detailTitle = 'Detalles de Reportes';
      description = 'Total de informes de novedades y reportes oficiales cargados al sistema y sincronizados con la central de seguridad.';
      indicators = [
        {'title': 'Novedades Críticas', 'value': '8 reportes'},
        {'title': 'Novedades Leves', 'value': '24 reportes'},
        {'title': 'Mensajes en Muro', 'value': '10 posts'},
        {'title': 'Tasa de Sincronización', 'value': '100%'},
      ];
    } else if (label.contains('SOS')) {
      detailTitle = 'Atención de Emergencias';
      description = 'Número de alertas SOS emitidas por ciudadanos o activadas por la central a las cuales has acudido y brindado respuesta inmediata.';
      indicators = [
        {'title': 'Tiempo de Respuesta Prom.', 'value': '3.2 min'},
        {'title': 'Emergencias de Tránsito', 'value': '4 casos'},
        {'title': 'Apoyo Policial/Asistencial', 'value': '11 casos'},
        {'title': 'Satisfacción Ciudadana', 'value': '98%'},
      ];
    } else {
      detailTitle = 'Desempeño Profesional';
      description = 'Evaluación integral del desempeño emitida por el Supervisor General de Serenazgo basada en puntualidad, efectividad y vocación de servicio.';
      indicators = [
        {'title': 'Puntualidad y Asistencia', 'value': '5.0 / 5.0'},
        {'title': 'Calidad de Reportes', 'value': '4.8 / 5.0'},
        {'title': 'Trabajo en Equipo', 'value': '4.9 / 5.0'},
        {'title': 'Última Evaluación', 'value': 'Hace 2 días'},
      ];
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: cardBorderColor, width: 1.2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cabecera del Modal con Icono Animado
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: accentColor, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailTitle,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Desempeño Oficial',
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: textColor.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, color: textColor.withValues(alpha: 0.6), size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Cifra Destacada
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Valor Registrado:',
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            value,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Descripción del Indicador
                    Text(
                      description,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lista de Sub-indicadores
                    Text(
                      'Desglose Técnico',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: indicators.map((ind) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ind['title']!,
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.6),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                ind['value']!,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Botón de Cierre
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Entendido',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionList(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
    String currentName,
    String? currentAvatarUrl,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorderColor, width: 1.5),
          ),
          child: Column(
            children: [
              _buildActionTile(
                theme,
                textColor,
                subTextColor,
                Iconsax.user_edit,
                'Editar Datos Personales',
                'Cambia tu nombre, apellidos y foto de perfil',
                onTap: () => _showEditProfileModal(context, theme, currentName, currentAvatarUrl),
              ),
              Divider(height: 1, color: cardBorderColor),
              _buildActionTile(theme, textColor, subTextColor, Iconsax.setting, 'Preferencias de Sector', 'Configura tu zona de patrullaje principal'),
              Divider(height: 1, color: cardBorderColor),
              _buildActionTile(theme, textColor, subTextColor, Iconsax.shield_security, 'Seguridad y PIN', 'Actualizar tu clave de acceso'),
              Divider(height: 1, color: cardBorderColor),
              _buildActionTile(theme, textColor, subTextColor, Iconsax.info_circle, 'Soporte y Ayuda', 'Contactar con la Jefatura'),
              Divider(height: 1, color: cardBorderColor),
              _buildActionTile(
                theme,
                textColor,
                subTextColor,
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
        ),
      ),
    );
  }

  Widget _buildActionTile(
    ThemeData theme,
    Color textColor,
    Color subTextColor,
    IconData icon,
    String title,
    String subtitle, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Icon(icon, color: color ?? theme.colorScheme.primary, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: TextStyle(color: subTextColor, fontSize: 12),
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: subTextColor.withValues(alpha: 0.6), size: 20),
      onTap: onTap,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MODAL BOTTOM SHEET GLASSMORPHIC DE EDICIÓN DE PERFIL
  // ─────────────────────────────────────────────────────────────
  void _showEditProfileModal(
    BuildContext context,
    ThemeData theme,
    String currentName,
    String? currentAvatarUrl,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final nameCtrl = TextEditingController(text: currentName);
    String? selectedAvatarUrl = currentAvatarUrl;
    bool isUploading = false;

    // Tokens visuales para el modal
    final modalBg = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.95);
    final borderCol = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.8)
        : const Color(0xFFE2E8F0);
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickAndUploadAvatar() async {
              try {
                setModalState(() => isUploading = true);

                final result = await FilePicker.pickFiles(
                  type: FileType.image,
                  allowMultiple: false,
                );

                if (result != null && result.files.single.path != null) {
                  final filePath = result.files.single.path!;
                  final fileName = result.files.single.name;

                  final supabase = Supabase.instance.client;
                  final file = File(filePath);
                  
                  final timestamp = DateTime.now().millisecondsSinceEpoch;
                  final pathInBucket = 'avatars/${timestamp}_$fileName';

                  // Subir a Supabase Storage (muro_attachments tiene políticas públicas)
                  await supabase.storage.from('muro_attachments').upload(pathInBucket, file);
                  final publicUrl = supabase.storage.from('muro_attachments').getPublicUrl(pathInBucket);

                  setModalState(() {
                    selectedAvatarUrl = publicUrl;
                    isUploading = false;
                  });
                } else {
                  setModalState(() => isUploading = false);
                }
              } catch (e) {
                setModalState(() => isUploading = false);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al subir la imagen: ${e.toString()}'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: modalBg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      border: Border(top: BorderSide(color: borderCol, width: 1.5)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Barra superior indicadora
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: textCol.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Editar Perfil de Sereno',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textCol,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Seleccionador de Foto con Spinner
                        Center(
                          child: GestureDetector(
                            onTap: isUploading ? null : pickAndUploadAvatar,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: (selectedAvatarUrl != null && selectedAvatarUrl!.isNotEmpty)
                                      ? NetworkImage(selectedAvatarUrl!) as ImageProvider
                                      : const AssetImage('assets/images/default_user.png'),
                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                ),
                                if (isUploading)
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.black54,
                                    child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF00F2FF)),
                                  )
                                else
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.black26,
                                    child: Icon(Iconsax.camera, color: Colors.white.withValues(alpha: 0.8), size: 28),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isUploading ? 'Subiendo imagen...' : 'Toca para cambiar la foto de perfil',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textCol.withValues(alpha: 0.5), fontSize: 12),
                        ),
                        const SizedBox(height: 24),

                        // Input del Nombre y Apellidos
                        Text(
                          'Nombre y Apellidos completos',
                          style: TextStyle(
                            color: textCol.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nameCtrl,
                          style: TextStyle(color: textCol),
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu nombre y apellidos',
                            prefixIcon: const Icon(Iconsax.user, size: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: borderCol, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Botón de Guardado
                        ElevatedButton.icon(
                          onPressed: isUploading
                              ? null
                              : () {
                                  final name = nameCtrl.text.trim();
                                  if (name.isNotEmpty) {
                                    context.read<AuthBloc>().add(UpdateProfileRequested(
                                          fullName: name,
                                          avatarUrl: selectedAvatarUrl,
                                        ));
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('¡Perfil sincronizado con éxito!'),
                                        backgroundColor: theme.colorScheme.primary,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                          icon: const Icon(Iconsax.document_upload),
                          label: const Text('Sincronizar con Base de Datos', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPONENTE DE BADGE PULSANTE DE ESTADO
// ─────────────────────────────────────────────────────────────
class _PulsingActiveBadge extends StatefulWidget {
  final bool isNight;
  const _PulsingActiveBadge({required this.isNight});

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
    final badgeColor = widget.isNight ? const Color(0xFF00F2FF) : Colors.amber;
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
                color: badgeColor.withValues(alpha: 0.3 * (1 - _pulseCtrl.value)),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }
}
