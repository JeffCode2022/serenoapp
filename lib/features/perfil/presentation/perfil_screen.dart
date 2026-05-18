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
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

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
              const _PulsingActiveBadge(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turno Activo • Patrullaje de Noche',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fin de turno: 06:00 AM • Unidad M-09',
                      style: TextStyle(color: subTextColor, fontSize: 12),
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
                color: Colors.green.withValues(alpha: 0.3 * (1 - _pulseCtrl.value)),
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
