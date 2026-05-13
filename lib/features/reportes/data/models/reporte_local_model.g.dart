// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporte_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReporteLocalCollection on Isar {
  IsarCollection<ReporteLocal> get reporteLocals => this.collection();
}

const ReporteLocalSchema = CollectionSchema(
  name: r'ReporteLocal',
  id: 5175957689718065279,
  properties: {
    r'apoyo': PropertySchema(
      id: 0,
      name: r'apoyo',
      type: IsarType.string,
    ),
    r'codigoOcurrenciaAsignado': PropertySchema(
      id: 1,
      name: r'codigoOcurrenciaAsignado',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'direccion': PropertySchema(
      id: 3,
      name: r'direccion',
      type: IsarType.string,
    ),
    r'fecha': PropertySchema(
      id: 4,
      name: r'fecha',
      type: IsarType.dateTime,
    ),
    r'isSynced': PropertySchema(
      id: 5,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'jefeOperaciones': PropertySchema(
      id: 6,
      name: r'jefeOperaciones',
      type: IsarType.string,
    ),
    r'novedad': PropertySchema(
      id: 7,
      name: r'novedad',
      type: IsarType.string,
    ),
    r'supervisorZona': PropertySchema(
      id: 8,
      name: r'supervisorZona',
      type: IsarType.string,
    ),
    r'zona': PropertySchema(
      id: 9,
      name: r'zona',
      type: IsarType.string,
    )
  },
  estimateSize: _reporteLocalEstimateSize,
  serialize: _reporteLocalSerialize,
  deserialize: _reporteLocalDeserialize,
  deserializeProp: _reporteLocalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _reporteLocalGetId,
  getLinks: _reporteLocalGetLinks,
  attach: _reporteLocalAttach,
  version: '3.1.0+1',
);

int _reporteLocalEstimateSize(
  ReporteLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.apoyo.length * 3;
  bytesCount += 3 + object.codigoOcurrenciaAsignado.length * 3;
  bytesCount += 3 + object.direccion.length * 3;
  bytesCount += 3 + object.jefeOperaciones.length * 3;
  bytesCount += 3 + object.novedad.length * 3;
  bytesCount += 3 + object.supervisorZona.length * 3;
  bytesCount += 3 + object.zona.length * 3;
  return bytesCount;
}

void _reporteLocalSerialize(
  ReporteLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.apoyo);
  writer.writeString(offsets[1], object.codigoOcurrenciaAsignado);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.direccion);
  writer.writeDateTime(offsets[4], object.fecha);
  writer.writeBool(offsets[5], object.isSynced);
  writer.writeString(offsets[6], object.jefeOperaciones);
  writer.writeString(offsets[7], object.novedad);
  writer.writeString(offsets[8], object.supervisorZona);
  writer.writeString(offsets[9], object.zona);
}

ReporteLocal _reporteLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReporteLocal();
  object.apoyo = reader.readString(offsets[0]);
  object.codigoOcurrenciaAsignado = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.direccion = reader.readString(offsets[3]);
  object.fecha = reader.readDateTime(offsets[4]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[5]);
  object.jefeOperaciones = reader.readString(offsets[6]);
  object.novedad = reader.readString(offsets[7]);
  object.supervisorZona = reader.readString(offsets[8]);
  object.zona = reader.readString(offsets[9]);
  return object;
}

P _reporteLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reporteLocalGetId(ReporteLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reporteLocalGetLinks(ReporteLocal object) {
  return [];
}

void _reporteLocalAttach(
    IsarCollection<dynamic> col, Id id, ReporteLocal object) {
  object.id = id;
}

extension ReporteLocalQueryWhereSort
    on QueryBuilder<ReporteLocal, ReporteLocal, QWhere> {
  QueryBuilder<ReporteLocal, ReporteLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReporteLocalQueryWhere
    on QueryBuilder<ReporteLocal, ReporteLocal, QWhereClause> {
  QueryBuilder<ReporteLocal, ReporteLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReporteLocalQueryFilter
    on QueryBuilder<ReporteLocal, ReporteLocal, QFilterCondition> {
  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> apoyoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apoyo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      apoyoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'apoyo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> apoyoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'apoyo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> apoyoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'apoyo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      apoyoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'apoyo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> apoyoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'apoyo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> apoyoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'apoyo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> apoyoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'apoyo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      apoyoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apoyo',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      apoyoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'apoyo',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigoOcurrenciaAsignado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'codigoOcurrenciaAsignado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'codigoOcurrenciaAsignado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'codigoOcurrenciaAsignado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'codigoOcurrenciaAsignado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'codigoOcurrenciaAsignado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'codigoOcurrenciaAsignado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'codigoOcurrenciaAsignado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigoOcurrenciaAsignado',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      codigoOcurrenciaAsignadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'codigoOcurrenciaAsignado',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'direccion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'direccion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'direccion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'direccion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'direccion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'direccion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'direccion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'direccion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'direccion',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      direccionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'direccion',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> fechaEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fecha',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      fechaGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fecha',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> fechaLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fecha',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> fechaBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fecha',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jefeOperaciones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jefeOperaciones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jefeOperaciones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jefeOperaciones',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jefeOperaciones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jefeOperaciones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jefeOperaciones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jefeOperaciones',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jefeOperaciones',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      jefeOperacionesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jefeOperaciones',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'novedad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'novedad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'novedad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'novedad',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'novedad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'novedad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'novedad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'novedad',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'novedad',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      novedadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'novedad',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supervisorZona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supervisorZona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supervisorZona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supervisorZona',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supervisorZona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supervisorZona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supervisorZona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supervisorZona',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supervisorZona',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      supervisorZonaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supervisorZona',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> zonaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      zonaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> zonaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> zonaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zona',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      zonaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'zona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> zonaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'zona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> zonaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'zona',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition> zonaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'zona',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      zonaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zona',
        value: '',
      ));
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterFilterCondition>
      zonaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zona',
        value: '',
      ));
    });
  }
}

extension ReporteLocalQueryObject
    on QueryBuilder<ReporteLocal, ReporteLocal, QFilterCondition> {}

extension ReporteLocalQueryLinks
    on QueryBuilder<ReporteLocal, ReporteLocal, QFilterCondition> {}

extension ReporteLocalQuerySortBy
    on QueryBuilder<ReporteLocal, ReporteLocal, QSortBy> {
  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByApoyo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apoyo', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByApoyoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apoyo', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      sortByCodigoOcurrenciaAsignado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoOcurrenciaAsignado', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      sortByCodigoOcurrenciaAsignadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoOcurrenciaAsignado', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByDireccion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direccion', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByDireccionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direccion', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByFecha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fecha', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByFechaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fecha', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      sortByJefeOperaciones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jefeOperaciones', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      sortByJefeOperacionesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jefeOperaciones', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByNovedad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novedad', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByNovedadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novedad', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      sortBySupervisorZona() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorZona', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      sortBySupervisorZonaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorZona', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByZona() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zona', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> sortByZonaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zona', Sort.desc);
    });
  }
}

extension ReporteLocalQuerySortThenBy
    on QueryBuilder<ReporteLocal, ReporteLocal, QSortThenBy> {
  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByApoyo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apoyo', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByApoyoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apoyo', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      thenByCodigoOcurrenciaAsignado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoOcurrenciaAsignado', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      thenByCodigoOcurrenciaAsignadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigoOcurrenciaAsignado', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByDireccion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direccion', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByDireccionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'direccion', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByFecha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fecha', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByFechaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fecha', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      thenByJefeOperaciones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jefeOperaciones', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      thenByJefeOperacionesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jefeOperaciones', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByNovedad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novedad', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByNovedadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novedad', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      thenBySupervisorZona() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorZona', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy>
      thenBySupervisorZonaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorZona', Sort.desc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByZona() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zona', Sort.asc);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QAfterSortBy> thenByZonaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zona', Sort.desc);
    });
  }
}

extension ReporteLocalQueryWhereDistinct
    on QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> {
  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByApoyo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apoyo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct>
      distinctByCodigoOcurrenciaAsignado({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'codigoOcurrenciaAsignado',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByDireccion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'direccion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByFecha() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fecha');
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByJefeOperaciones(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jefeOperaciones',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByNovedad(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novedad', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctBySupervisorZona(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supervisorZona',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReporteLocal, ReporteLocal, QDistinct> distinctByZona(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zona', caseSensitive: caseSensitive);
    });
  }
}

extension ReporteLocalQueryProperty
    on QueryBuilder<ReporteLocal, ReporteLocal, QQueryProperty> {
  QueryBuilder<ReporteLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations> apoyoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apoyo');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations>
      codigoOcurrenciaAsignadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codigoOcurrenciaAsignado');
    });
  }

  QueryBuilder<ReporteLocal, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations> direccionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'direccion');
    });
  }

  QueryBuilder<ReporteLocal, DateTime, QQueryOperations> fechaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fecha');
    });
  }

  QueryBuilder<ReporteLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations>
      jefeOperacionesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jefeOperaciones');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations> novedadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novedad');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations>
      supervisorZonaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supervisorZona');
    });
  }

  QueryBuilder<ReporteLocal, String, QQueryOperations> zonaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zona');
    });
  }
}
