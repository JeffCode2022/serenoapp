class WhatsAppFormatter {
  static String generarReporte({
    required DateTime fecha,
    required String moduloSector,
    required String lugar,
    required String jefeOperaciones,
    required String supervisorZona,
    required String novedad,
    required String apoyo,
  }) {
    final hora = "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')} hs";
    final dia = "${fecha.day} de ${_mes(fecha.month)} de ${fecha.year}";

    return '''📋 *Reporte de Incidencia – Municipalidad de Surquillo*
📅 *Fecha:* $dia
⏰ *Hora:* $hora
📍 *Zona:* $moduloSector
*Lugar:* $lugar
🧑💼 *Jefe de Operaciones:* $jefeOperaciones
👔 *Supervisor de Zona:* $supervisorZona

📝 *Novedad:*
$novedad

🚓 *Apoyo de Serenazgo / 🏍️ Lince:*
$apoyo

📎 Se adjuntan fotos y/o evidencia fílmica. 📸''';
  }

  static String _mes(int m) {
    const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return meses[m - 1];
  }
}
