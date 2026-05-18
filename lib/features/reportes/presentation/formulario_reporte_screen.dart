import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/utils/whatsapp_formatter.dart';

class FormularioReporteScreen extends StatefulWidget {
  final bool isEmbedded;
  const FormularioReporteScreen({super.key, this.isEmbedded = false});

  @override
  State<FormularioReporteScreen> createState() => _FormularioReporteScreenState();
}

class _FormularioReporteScreenState extends State<FormularioReporteScreen> {
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _novedadController = TextEditingController();
  final TextEditingController _apoyoController = TextEditingController();
  
  String _sectorSeleccionado = 'Sector 03 / Módulo 11';
  final String _jefeOperaciones = 'Sisniegas Ángeles Piero Eduardo';
  String _supervisor = 'Genaro Rojas Buleje';

  void _generarYEnviarWhatsApp() async {
    final mensaje = WhatsAppFormatter.generarReporte(
      fecha: DateTime.now(),
      moduloSector: _sectorSeleccionado,
      lugar: _lugarController.text,
      jefeOperaciones: _jefeOperaciones,
      supervisorZona: _supervisor,
      novedad: _novedadController.text,
      apoyo: _apoyoController.text.isEmpty ? 'Ninguno' : _apoyoController.text,
    );

    // Codificar para URL
    final url = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(mensaje)}');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Intentar enlace web si no hay app instalada
      final webUrl = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(mensaje)}');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir WhatsApp')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Zona y Jefaturas (Pre-llenados)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _sectorSeleccionado,
                    decoration: const InputDecoration(labelText: 'Zona'),
                    items: ['Sector 03 / Módulo 11', 'Sector 03 / Módulo 12']
                        .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                        .toList(),
                    onChanged: (v) => setState(() => _sectorSeleccionado = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _supervisor,
                    decoration: const InputDecoration(labelText: 'Supervisor de Zona'),
                    items: ['Genaro Rojas Buleje', 'Jorge Zevallos', 'Jose Valdivia del Alamo']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _supervisor = v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Campos de la ocurrencia
          TextField(
            controller: _lugarController,
            decoration: const InputDecoration(
              labelText: 'Lugar Exacto',
              hintText: 'Ej: Av. Aviación cdra 46',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _novedadController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Novedad (Detalles de intervención)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _apoyoController,
            decoration: const InputDecoration(
              labelText: 'Apoyo (Serenazgo / Lince)',
              hintText: 'Ej: Lince Chunga Zapata Jefferson',
              prefixIcon: Icon(Icons.local_police),
            ),
          ),
          
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _generarYEnviarWhatsApp,
            icon: const Icon(Icons.send),
            label: const Text('GENERAR Y ABRIR WHATSAPP'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366), // Color WhatsApp
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.isEmbedded) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Reporte Oficial'),
      ),
      body: bodyContent,
    );
  }
}
