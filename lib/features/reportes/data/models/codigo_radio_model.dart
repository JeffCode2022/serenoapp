import 'package:isar/isar.dart';

part 'codigo_radio_model.g.dart';

@collection
class CodigoRadio {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String codigo; // ej: '10-00'

  @Index(type: IndexType.value)
  late String significado; // ej: 'DISPONIBLE'
}
