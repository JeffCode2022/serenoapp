import 'package:isar/isar.dart';

part 'reporte_local_model.g.dart';

@collection
class ReporteLocal {
  Id id = Isar.autoIncrement;

  late DateTime fecha;
  late String zona;
  late String direccion;
  late String jefeOperaciones;
  late String supervisorZona;
  late String novedad;
  late String apoyo;
  
  // Si tiene un código de intervención oficial
  late String codigoOcurrenciaAsignado;

  // Manejo offline
  bool isSynced = false;
  late DateTime createdAt;
}
