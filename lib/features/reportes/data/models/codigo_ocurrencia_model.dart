import 'package:isar/isar.dart';

part 'codigo_ocurrencia_model.g.dart';

@collection
class CodigoOcurrencia {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String codigo; // ej: '010301'

  @Index(type: IndexType.value)
  late String descripcion; // ej: 'PRESUNTO ROBO A PERSONAS'

  late String categoria; // ej: 'PRESUNTAS ACTIVIDADES CONTRA EL PATRIMONIO'
}
