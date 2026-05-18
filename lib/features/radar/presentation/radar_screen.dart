import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Pantalla de Radar Premium con un Mapa Interactivo de Surquillo
/// con estilo minimalista/grisáceo (tipo Uber) dinámico según el tema del dispositivo.
/// Permite rastrear patrullas, centrar incidentes SOS e interactuar en tiempo real.
class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  final MapController _mapController = MapController();
  String _selectedFilter = 'Todos';
  Map<String, dynamic>? _selectedPatrol;

  // Centro de Surquillo (Sector 3)
  final LatLng _initialCenter = const LatLng(-12.115, -77.018);

  // Mocks de patrullas y eventos en Surquillo (Sector 3)
  final List<Map<String, dynamic>> _patrols = [
    {
      'id': 'P-03',
      'name': 'Patrullero Móvil 11',
      'sereno': 'Gómez Chunga Alberto',
      'sector': 'Sector 3 - Subzona A',
      'vehicle': 'Camioneta Toyota Hilux - EP-204',
      'status': 'Patrullando',
      'signal': 'Excelente',
      'lat': -12.112,
      'lng': -77.022,
      'isSos': false,
    },
    {
      'id': 'M-09',
      'name': 'Motorizado Línea 4',
      'sereno': 'Zapata Jefferson',
      'sector': 'Sector 3 - Subzona B',
      'vehicle': 'Motocicleta Honda XR 250',
      'status': 'Intervención activa',
      'signal': 'Estable',
      'lat': -12.118,
      'lng': -77.015,
      'isSos': false,
    },
    {
      'id': 'SOS-01',
      'name': 'Alerta Crítica SOS',
      'sereno': 'Vecino Anónimo',
      'sector': 'Av. Angamos Este cdra. 12',
      'vehicle': 'Dispositivo Móvil - Botón de Pánico',
      'status': '¡Emergencia Reportada!',
      'signal': 'Crítica',
      'lat': -12.114,
      'lng': -77.019,
      'isSos': true,
    },
    {
      'id': 'P-12',
      'name': 'Patrullero Móvil 12',
      'sereno': 'Sisniegas Ángeles Piero',
      'sector': 'Sector 3 - Subzona C',
      'vehicle': 'Camioneta Nissan Frontier - EP-209',
      'status': 'Patrullando',
      'signal': 'Excelente',
      'lat': -12.120,
      'lng': -77.025,
      'isSos': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredPatrols {
    if (_selectedFilter == 'Patrullas') {
      return _patrols.where((p) => !p['isSos']).toList();
    }
    if (_selectedFilter == 'SOS') {
      return _patrols.where((p) => p['isSos']).toList();
    }
    return _patrols;
  }

  void _centerMapOn(double lat, double lng, {double zoom = 16.0}) {
    _mapController.move(LatLng(lat, lng), zoom);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Tokens de diseño Liquid Glass
    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.85)
        : Colors.white.withValues(alpha: 0.9);

    final cardBorderColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.8)
        : const Color(0xFFE2E8F0);

    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.grey[400]! : const Color(0xFF475569);

    final shadowColor = isDark
        ? const Color(0xFF00F2FF).withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Mapa de Flutter interactivo con estilo minimalista grisáceo
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: 14.5,
                minZoom: 12.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: isDark
                      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                      : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'pe.surquillo.serenazgo_app',
                ),
                MarkerLayer(
                  markers: _filteredPatrols.map((patrol) {
                    final isSos = patrol['isSos'] as bool;
                    final isSelected = _selectedPatrol?['id'] == patrol['id'];
                    final lat = patrol['lat'] as double;
                    final lng = patrol['lng'] as double;

                    return Marker(
                      point: LatLng(lat, lng),
                      width: 60.0,
                      height: 60.0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPatrol = patrol;
                          });
                          _centerMapOn(lat, lng, zoom: 16.0);
                        },
                        child: _MarkerWidget(
                          isSos: isSos,
                          isSelected: isSelected,
                          name: patrol['id'] as String,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // 2. Brújula y Botón de Recetear Vista en Esquina Derecha
          Positioned(
            top: 80,
            right: 16,
            child: Column(
              children: [
                _buildCircularActionButton(
                  theme,
                  isDark,
                  cardBgColor,
                  cardBorderColor,
                  textColor,
                  Iconsax.gps,
                  onTap: () {
                    setState(() {
                      _selectedPatrol = null;
                    });
                    _centerMapOn(_initialCenter.latitude, _initialCenter.longitude, zoom: 14.5);
                  },
                ),
              ],
            ),
          ),

          // 3. Filtros superiores adaptativos
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildTopFilters(theme, isDark, cardBgColor, cardBorderColor, textColor),
          ),

          // 4. Panel inferior de detalle / resumen (Glassmorphic)
          if (_selectedPatrol != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildDetailCard(theme, isDark, cardBgColor, cardBorderColor, textColor, subTextColor, shadowColor),
            )
          else
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _buildMapStatsOverview(theme, isDark, cardBgColor, cardBorderColor, textColor, subTextColor),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularActionButton(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        shape: BoxShape.circle,
        border: Border.all(color: cardBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.primary, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildTopFilters(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorderColor, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Todos', 'Patrullas', 'SOS'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                      _selectedPatrol = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.5))
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? theme.colorScheme.primary : textColor.withValues(alpha: 0.7),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
    Color shadowColor,
  ) {
    final isSos = _selectedPatrol!['isSos'] as bool;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSos ? Colors.redAccent.withValues(alpha: 0.7) : cardBorderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: isSos
                          ? Colors.red.withValues(alpha: 0.1)
                          : theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(
                        isSos ? Iconsax.danger : Iconsax.personalcard,
                        color: isSos ? Colors.redAccent : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedPatrol!['name'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _selectedPatrol!['sereno'] as String,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: subTextColor, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedPatrol = null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: cardBorderColor),
                const SizedBox(height: 12),
                _buildDetailRow(textColor, subTextColor, Iconsax.routing, 'Zona / Sector', _selectedPatrol!['sector'] as String),
                _buildDetailRow(textColor, subTextColor, Iconsax.truck, 'Vehículo', _selectedPatrol!['vehicle'] as String),
                _buildDetailRow(textColor, subTextColor, Iconsax.status, 'Estado actual', _selectedPatrol!['status'] as String),
                _buildDetailRow(textColor, subTextColor, Iconsax.wifi, 'Señal GPS', _selectedPatrol!['signal'] as String,
                    color: isSos ? Colors.redAccent : Colors.green),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Iconsax.call, size: 18),
                        label: const Text('Llamar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          foregroundColor: textColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          side: BorderSide(color: cardBorderColor, width: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Iconsax.message_2, size: 18),
                        label: const Text('Despachar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSos ? Colors.redAccent : theme.colorScheme.primary,
                          foregroundColor: isSos ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                      ),
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

  Widget _buildDetailRow(
    Color textColor,
    Color subTextColor,
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: subTextColor.withValues(alpha: 0.7), size: 16),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: subTextColor, fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? textColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStatsOverview(
    ThemeData theme,
    bool isDark,
    Color cardBgColor,
    Color cardBorderColor,
    Color textColor,
    Color subTextColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorderColor, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('3', 'Patrullas Activas', theme.colorScheme.primary, subTextColor),
              Container(width: 1, height: 30, color: cardBorderColor),
              _buildStatItem('1', 'Emergencias SOS', Colors.redAccent, subTextColor),
              Container(width: 1, height: 30, color: cardBorderColor),
              _buildStatItem('Sector 03', 'Tu Cobertura', Colors.green, subTextColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label, Color col, Color subTextColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: subTextColor, fontSize: 11)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MARCADOR FLOTANTE E INTERACTIVO EN EL MAPA
// ─────────────────────────────────────────────────────────────
class _MarkerWidget extends StatefulWidget {
  final bool isSos;
  final bool isSelected;
  final String name;

  const _MarkerWidget({
    required this.isSos,
    required this.isSelected,
    required this.name,
  });

  @override
  State<_MarkerWidget> createState() => _MarkerWidgetState();
}

class _MarkerWidgetState extends State<_MarkerWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isSos ? Colors.redAccent : const Color(0xFF00F2FF);

    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Círculo de pulso expansivo
            Container(
              width: 48 * (1 + _pulseCtrl.value * 0.4),
              height: 48 * (1 + _pulseCtrl.value * 0.4),
              decoration: BoxDecoration(
                color: baseColor.withValues(alpha: 0.25 * (1 - _pulseCtrl.value)),
                shape: BoxShape.circle,
              ),
            ),
            // Círculo de fondo sólido
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSelected ? Colors.white : baseColor,
                  width: widget.isSelected ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.isSos ? Iconsax.danger : Iconsax.truck,
                  color: baseColor,
                  size: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
