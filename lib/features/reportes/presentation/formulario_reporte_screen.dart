import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../domain/utils/whatsapp_formatter.dart';

/// Formulario Oficial de Reportes con un Mapa Interactivo integrado (Uber-style)
/// que permite geolocalizar y autocompletar la dirección de la incidencia en tiempo real,
/// seleccionar la cadena de mando de Surquillo Sector 3, y despachar el reporte directamente a WhatsApp.
class FormularioReporteScreen extends StatefulWidget {
  final bool isEmbedded;
  const FormularioReporteScreen({super.key, this.isEmbedded = false});

  @override
  State<FormularioReporteScreen> createState() => _FormularioReporteScreenState();
}

class _FormularioReporteScreenState extends State<FormularioReporteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _novedadController = TextEditingController();
  final TextEditingController _apoyoController = TextEditingController();
  final TextEditingController _especificarController = TextEditingController();

  final MapController _mapController = MapController();
  LatLng _coordActual = const LatLng(-12.115, -77.018); // Centro de Surquillo
  bool _cargandoUbicacion = false;

  String _sectorSeleccionado = 'Módulo 11';
  final String _jefeOperaciones = 'Sisniegas Ángeles Piero Eduardo';
  final String _supervisor = 'Genaro Rojas Buleje'; // Único supervisor en la Zona 3
  String _apoloSeleccionado = 'Jorge Zevallos Lora'; // Jorge Zevallos Lora y José Luis Valdivia del Álamo

  @override
  void initState() {
    super.initState();
    // Autocompletar la ubicación inicial
    _obtenerDireccionReverseGeocoding(_coordActual.latitude, _coordActual.longitude);
  }

  Future<void> _obtenerDireccionReverseGeocoding(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&accept-language=es'),
        headers: {'User-Agent': 'pe.surquillo.serenazgo_app'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['display_name'] as String?;
        if (address != null) {
          final parts = address.split(',');
          // Tomar los detalles principales (calle, número, cruce)
          final cleanAddress = parts.take(3).join(',').trim();
          setState(() {
            _lugarController.text = cleanAddress;
          });
        }
      }
    } catch (_) {
      // Fallback silencioso en caso de estar sin conexión
    }
  }

  Future<void> _geolocalizarDispositivo() async {
    setState(() {
      _cargandoUbicacion = true;
    });

    try {
      // Simulación de geolocalización de alta precisión en Surquillo
      final double lat = -12.115 + (math.Random().nextDouble() - 0.5) * 0.008;
      final double lng = -77.018 + (math.Random().nextDouble() - 0.5) * 0.008;

      setState(() {
        _coordActual = LatLng(lat, lng);
      });

      _mapController.move(_coordActual, 16.0);
      await _obtenerDireccionReverseGeocoding(lat, lng);
    } catch (_) {
      setState(() {
        _lugarController.text = "Sector 3, Surquillo, Lima";
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargandoUbicacion = false;
        });
      }
    }
  }

  void _generarYEnviarWhatsApp() async {
    if (!_formKey.currentState!.validate()) return;

    final String sectorReporte = _sectorSeleccionado == 'Otro (Especificar)'
        ? 'Especificar: ${_especificarController.text.trim()}'
        : _sectorSeleccionado;

    final mensaje = WhatsAppFormatter.generarReporte(
      fecha: DateTime.now(),
      moduloSector: sectorReporte,
      lugar: _lugarController.text.trim(),
      jefeOperaciones: _jefeOperaciones,
      supervisorZona: _supervisor,
      apoloJefeZona: _apoloSeleccionado,
      novedad: _novedadController.text.trim(),
      apoyo: _apoyoController.text.isEmpty ? 'Ninguno' : _apoyoController.text.trim(),
    );

    // Codificar para URL
    final url = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(mensaje)}');
    final webUrl = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(mensaje)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Tokens visuales Liquid Glass
    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.85);

    final cardBorderColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.6)
        : const Color(0xFFE2E8F0);

    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    final formWidget = Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🗺️ MAPA INTERACTIVO INTEGRADO (Grisáceo Uber-style)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cardBorderColor, width: 1.2),
                ),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _coordActual,
                        initialZoom: 15.0,
                        minZoom: 12.0,
                        maxZoom: 18.0,
                        onTap: (_, point) {
                          setState(() {
                            _coordActual = point;
                          });
                          _obtenerDireccionReverseGeocoding(point.latitude, point.longitude);
                        },
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
                          markers: [
                            Marker(
                              point: _coordActual,
                              width: 50,
                              height: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: (isDark ? const Color(0xFF00F2FF) : const Color(0xFF6366F1)).withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Instrucción en el mapa
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                                : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Text(
                          'Toca el mapa para mover la ubicación',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Botón Geolocalizar
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: FloatingActionButton.small(
                        heroTag: 'geolocalizar_reporte',
                        onPressed: _cargandoUbicacion ? null : _geolocalizarDispositivo,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        child: _cargandoUbicacion
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: isDark ? Colors.black : Colors.white),
                              )
                            : const Icon(Icons.gps_fixed, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🏛️ CADENA DE MANDO Y JEFATURAS (Sector 3)
            ClipRRect(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.security, color: theme.colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Comando Serenazgo Sector 3',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _sectorSeleccionado,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: 'Zona Operativa (Módulo de Zona 3)',
                          prefixIcon: Icon(Iconsax.routing),
                        ),
                        items: ['Módulo 09', 'Módulo 10', 'Módulo 11', 'Módulo 14', 'Módulo 15', 'Módulo 16', 'Otro (Especificar)']
                            .map((z) => DropdownMenuItem(
                                  value: z,
                                  child: Text(
                                    z,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: textColor),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _sectorSeleccionado = v!),
                      ),
                      if (_sectorSeleccionado == 'Otro (Especificar)') ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _especificarController,
                          style: TextStyle(color: textColor),
                          decoration: const InputDecoration(
                            labelText: 'Especificar Lugar / Módulo Especial',
                            hintText: 'Ej: Parque Reducto, Apoyo táctico',
                            prefixIcon: Icon(Iconsax.edit),
                          ),
                          validator: (v) {
                            if (_sectorSeleccionado == 'Otro (Especificar)' && (v == null || v.trim().isEmpty)) {
                              return 'Por favor especifique el lugar o apoyo';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 14),
                      // Dropdown de Apolo (Jefe de Zona) - Jorge Zevallos Lora, José Luis Valdivia del Álamo
                      DropdownButtonFormField<String>(
                        value: _apoloSeleccionado,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: 'Apolo (Jefe de Zona)',
                          prefixIcon: Icon(Iconsax.personalcard),
                        ),
                        items: ['Jorge Zevallos Lora', 'José Luis Valdivia del Álamo']
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: textColor),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _apoloSeleccionado = v!),
                      ),
                      const SizedBox(height: 14),
                      // Supervisor (Fijo - Genaro Rojas Buleje)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Iconsax.profile_2user, color: theme.colorScheme.primary, size: 18),
                        ),
                        title: const Text('Supervisor de Zona (Zona 3)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        subtitle: Text(_supervisor, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      const Divider(),
                      // Jefe de Operaciones (Fijo - Sisniegas Piero)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Iconsax.star5, color: Colors.blueAccent, size: 18),
                        ),
                        title: const Text('Jefe de Operaciones', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        subtitle: Text(_jefeOperaciones, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✍️ DETALLES DE LA INCIDENCIA
            Text(
              'Detalles del Reporte',
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lugarController,
              decoration: const InputDecoration(
                labelText: 'Lugar Exacto (Autocompletado desde mapa)',
                hintText: 'Ej: Av. Aviación cdra 46',
                prefixIcon: Icon(Iconsax.location),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _novedadController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Novedad (Detalles de la intervención)',
                hintText: 'Describa los hechos ocurridos...',
                alignLabelWithHint: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Debe ingresar los detalles de la novedad';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apoyoController,
              decoration: const InputDecoration(
                labelText: 'Apoyo (Serenazgo / Motorizado / Lince)',
                hintText: 'Ej: Lince Chunga Alberto y Zapata Jefferson',
                prefixIcon: Icon(Iconsax.truck_fast),
              ),
            ),
            const SizedBox(height: 28),

            // 🟢 BOTÓN ENVIAR REPORTAR POR WHATSAPP
            ElevatedButton.icon(
              onPressed: _generarYEnviarWhatsApp,
              icon: const Icon(Icons.send, size: 20),
              label: const Text(
                'GENERAR Y ENVIAR POR WHATSAPP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.8),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // Color WhatsApp oficial
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF25D366).withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (widget.isEmbedded) {
      return bodyContent(context, formWidget, isDark);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Reporte Oficial'),
        centerTitle: true,
        elevation: 0,
      ),
      body: bodyContent(context, formWidget, isDark),
    );
  }

  Widget bodyContent(BuildContext context, Widget formWidget, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF0F172A),
                  Color(0xFF070B19),
                ]
              : const [
                  Color(0xFFF8FAFC),
                  Color(0xFFF1F5F9),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: formWidget,
    );
  }
}
