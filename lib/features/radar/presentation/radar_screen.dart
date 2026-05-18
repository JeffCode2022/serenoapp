import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Pantalla de Radar Premium con mapas vectoriales personalizados,
/// barrido de radar animado en tiempo real, marcadores de patrullas activos y SOS.
class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _radarAnimCtrl;
  String _selectedFilter = 'Todos';
  Map<String, dynamic>? _selectedPatrol;

  // Mocks de patrullas y eventos en Surquillo
  final List<Map<String, dynamic>> _patrols = [
    {
      'id': 'P-03',
      'name': 'Patrullero Móvil 11',
      'sereno': 'Gómez Chunga Alberto',
      'sector': 'Sector 3 - Subzona A',
      'vehicle': 'Camioneta Toyota Hilux - EP-204',
      'status': 'Patrullando',
      'signal': 'Excelente',
      'latOffset': 20.0,
      'lngOffset': -30.0,
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
      'latOffset': -40.0,
      'lngOffset': 60.0,
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
      'latOffset': 10.0,
      'lngOffset': 90.0,
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
      'latOffset': -80.0,
      'lngOffset': -60.0,
      'isSos': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _radarAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarAnimCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPatrols {
    if (_selectedFilter == 'Patrullas') {
      return _patrols.where((p) => !p['isSos']).toList();
    }
    if (_selectedFilter == 'SOS') {
      return _patrols.where((p) => p['isSos']).toList();
    }
    return _patrols;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fondo de mapa futurista/radar
          Positioned.fill(
            child: Container(
              color: const Color(0xFF070B19),
              child: AnimatedBuilder(
                animation: _radarAnimCtrl,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _RadarBackgroundPainter(
                      sweepAngle: _radarAnimCtrl.value * 2 * math.pi,
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Marcadores dinámicos e interactivos en el mapa
          Positioned.fill(
            child: _buildMarkersLayer(theme),
          ),

          // 3. Filtros superiores
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildTopFilters(theme),
          ),

          // 4. Panel inferior de detalle (Glassmorphic)
          if (_selectedPatrol != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildDetailCard(theme),
            )
          else
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _buildMapStatsOverview(theme),
            ),
        ],
      ),
    );
  }

  Widget _buildTopFilters(ThemeData theme) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
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
                  color: isSelected ? const Color(0xFF00F2FF).withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? Border.all(color: const Color(0xFF00F2FF).withOpacity(0.5)) : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF00F2FF) : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMarkersLayer(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        
        return Stack(
          children: _filteredPatrols.map((patrol) {
            final x = center.dx + (patrol['lngOffset'] as double);
            final y = center.dy + (patrol['latOffset'] as double);
            final isSos = patrol['isSos'] as bool;
            final isSelected = _selectedPatrol?['id'] == patrol['id'];

            return Positioned(
              left: x - 24,
              top: y - 24,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPatrol = patrol;
                  });
                },
                child: _MarkerWidget(
                  isSos: isSos,
                  isSelected: isSelected,
                  name: patrol['id'] as String,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDetailCard(ThemeData theme) {
    final isSos = _selectedPatrol!['isSos'] as bool;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSos ? Colors.red.withOpacity(0.5) : const Color(0xFF1E293B),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isSos ? Colors.red : const Color(0xFF00F2FF)).withOpacity(0.15),
            blurRadius: 20,
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
                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: isSos ? Colors.red.withOpacity(0.1) : const Color(0xFF00F2FF).withOpacity(0.1),
                  child: Icon(
                    isSos ? Iconsax.danger : Iconsax.personalcard,
                    color: isSos ? Colors.red : const Color(0xFF00F2FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPatrol!['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedPatrol!['sereno'] as String,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón cerrar
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                  onPressed: () {
                    setState(() {
                      _selectedPatrol = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF1E293B)),
            const SizedBox(height: 12),
            _buildDetailRow(Iconsax.routing, 'Zona / Sector', _selectedPatrol!['sector'] as String),
            _buildDetailRow(Iconsax.truck, 'Vehículo', _selectedPatrol!['vehicle'] as String),
            _buildDetailRow(Iconsax.status, 'Estado actual', _selectedPatrol!['status'] as String),
            _buildDetailRow(Iconsax.wifi, 'Señal GPS', _selectedPatrol!['signal'] as String,
                color: isSos ? Colors.red : Colors.green),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Iconsax.call, size: 18),
                    label: const Text('Llamar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                      backgroundColor: isSos ? Colors.red : const Color(0xFF00F2FF),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[500], size: 16),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.white,
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

  Widget _buildMapStatsOverview(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('3', 'Patrullas Activas', const Color(0xFF00F2FF)),
          Container(width: 1, height: 30, color: const Color(0xFF1E293B)),
          _buildStatItem('1', 'Emergencias SOS', Colors.red),
          Container(width: 1, height: 30, color: const Color(0xFF1E293B)),
          _buildStatItem('Sector 03', 'Tu Cobertura', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label, Color col) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
    final baseColor = widget.isSos ? Colors.red : const Color(0xFF00F2FF);

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
                color: baseColor.withOpacity(0.25 * (1 - _pulseCtrl.value)),
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
                    color: baseColor.withOpacity(0.5),
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

// ─────────────────────────────────────────────────────────────
// PAINTER DE RADAR DE ALTO RENDIMIENTO
// ─────────────────────────────────────────────────────────────
class _RadarBackgroundPainter extends CustomPainter {
  final double sweepAngle;

  _RadarBackgroundPainter({required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.8;

    final ringPaint = Paint()
      ..color = const Color(0xFF00F2FF).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final sweepPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00F2FF).withOpacity(0.12),
          const Color(0xFF00F2FF).withOpacity(0.02),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    // 1. Dibujar círculos concéntricos
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, (maxRadius / 4) * i, ringPaint);
    }

    // 2. Dibujar líneas de cuadrícula cruzadas
    final gridPaint = Paint()
      ..color = const Color(0xFF00F2FF).withOpacity(0.04)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), gridPaint);

    // 3. Barrido radial
    final rect = Rect.fromCircle(center: center, radius: maxRadius);
    canvas.drawArc(
      rect,
      sweepAngle - 0.5,
      0.5,
      true,
      sweepPaint,
    );

    // 4. Puntos aleatorios decorativos como "ecos de radar"
    final randomPointsPaint = Paint()
      ..color = const Color(0xFF00F2FF).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Mocks estáticos de señalización de radar
    canvas.drawCircle(center + const Offset(-100, -80), 2, randomPointsPaint);
    canvas.drawCircle(center + const Offset(120, 150), 3, randomPointsPaint);
    canvas.drawCircle(center + const Offset(70, -180), 2, randomPointsPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarBackgroundPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}
