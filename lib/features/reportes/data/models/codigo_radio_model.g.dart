// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'codigo_radio_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCodigoRadioCollection on Isar {
  IsarCollection<CodigoRadio> get codigoRadios => this.collection();
}

const CodigoRadioSchema = CollectionSchema(
  name: r'CodigoRadio',
  id: -9123231961398643704,
  properties: {
    r'codigo': PropertySchema(
      id: 0,
      name: r'codigo',
      type: IsarType.string,
    ),
    r'significado': PropertySchema(
      id: 1,
      name: r'significado',
      type: IsarType.string,
    )
  },
  estimateSize: _codigoRadioEstimateSize,
  serialize: _codigoRadioSerialize,
  deserialize: _codigoRadioDeserialize,
  deserializeProp: _codigoRadioDeserializeProp,
  idName: r'id',
  indexes: {
    r'codigo': IndexSchema(
      id: 2475659939796141935,
      name: r'codigo',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'codigo',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'significado': IndexSchema(
      id: -8405914330828074582,
      name: r'significado',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'significado',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _codigoRadioGetId,
  getLinks: _codigoRadioGetLinks,
  attach: _codigoRadioAttach,
  version: '3.1.0+1',
);

int _codigoRadioEstimateSize(
  CodigoRadio object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.codigo.length * 3;
  bytesCount += 3 + object.significado.length * 3;
  return bytesCount;
}

void _codigoRadioSerialize(
  CodigoRadio object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.codigo);
  writer.writeString(offsets[1], object.significado);
}

CodigoRadio _codigoRadioDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CodigoRadio();
  object.codigo = reader.readString(offsets[0]);
  object.id = id;
  object.significado = reader.readString(offsets[1]);
  return object;
}

P _codigoRadioDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _codigoRadioGetId(CodigoRadio object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _codigoRadioGetLinks(CodigoRadio object) {
  return [];
}

void _codigoRadioAttach(
    IsarCollection<dynamic> col, Id id, CodigoRadio object) {
  object.id = id;
}

extension CodigoRadioQueryWhereSort
    on QueryBuilder<CodigoRadio, CodigoRadio, QWhere> {
  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhere> anyCodigo() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'codigo'),
      );
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhere> anySignificado() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'significado'),
      );
    });
  }
}

extension CodigoRadioQueryWhere
    on QueryBuilder<CodigoRadio, CodigoRadio, QWhereClause> {
  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> idBetween(
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

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoEqualTo(
      String codigo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'codigo',
        value: [codigo],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoNotEqualTo(
      String codigo) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [],
              upper: [codigo],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [codigo],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [codigo],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [],
              upper: [codigo],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoGreaterThan(
    String codigo, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'codigo',
        lower: [codigo],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoLessThan(
    String codigo, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'codigo',
        lower: [],
        upper: [codigo],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoBetween(
    String lowerCodigo,
    String upperCodigo, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'codigo',
        lower: [lowerCodigo],
        includeLower: includeLower,
        upper: [upperCodigo],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoStartsWith(
      String CodigoPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'codigo',
        lower: [CodigoPrefix],
        upper: ['$CodigoPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'codigo',
        value: [''],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> codigoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'codigo',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'codigo',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'codigo',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'codigo',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> significadoEqualTo(
      String significado) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'significado',
        value: [significado],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause>
      significadoNotEqualTo(String significado) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'significado',
              lower: [],
              upper: [significado],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'significado',
              lower: [significado],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'significado',
              lower: [significado],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'significado',
              lower: [],
              upper: [significado],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause>
      significadoGreaterThan(
    String significado, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'significado',
        lower: [significado],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> significadoLessThan(
    String significado, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'significado',
        lower: [],
        upper: [significado],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause> significadoBetween(
    String lowerSignificado,
    String upperSignificado, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'significado',
        lower: [lowerSignificado],
        includeLower: includeLower,
        upper: [upperSignificado],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause>
      significadoStartsWith(String SignificadoPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'significado',
        lower: [SignificadoPrefix],
        upper: ['$SignificadoPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause>
      significadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'significado',
        value: [''],
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterWhereClause>
      significadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'significado',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'significado',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'significado',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'significado',
              upper: [''],
            ));
      }
    });
  }
}

extension CodigoRadioQueryFilter
    on QueryBuilder<CodigoRadio, CodigoRadio, QFilterCondition> {
  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> codigoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      codigoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> codigoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> codigoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'codigo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      codigoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> codigoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> codigoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> codigoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'codigo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      codigoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigo',
        value: '',
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      codigoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'codigo',
        value: '',
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'significado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'significado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'significado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'significado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'significado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'significado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'significado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'significado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'significado',
        value: '',
      ));
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterFilterCondition>
      significadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'significado',
        value: '',
      ));
    });
  }
}

extension CodigoRadioQueryObject
    on QueryBuilder<CodigoRadio, CodigoRadio, QFilterCondition> {}

extension CodigoRadioQueryLinks
    on QueryBuilder<CodigoRadio, CodigoRadio, QFilterCondition> {}

extension CodigoRadioQuerySortBy
    on QueryBuilder<CodigoRadio, CodigoRadio, QSortBy> {
  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> sortByCodigo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.asc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> sortByCodigoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.desc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> sortBySignificado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'significado', Sort.asc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> sortBySignificadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'significado', Sort.desc);
    });
  }
}

extension CodigoRadioQuerySortThenBy
    on QueryBuilder<CodigoRadio, CodigoRadio, QSortThenBy> {
  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> thenByCodigo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.asc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> thenByCodigoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.desc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> thenBySignificado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'significado', Sort.asc);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QAfterSortBy> thenBySignificadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'significado', Sort.desc);
    });
  }
}

extension CodigoRadioQueryWhereDistinct
    on QueryBuilder<CodigoRadio, CodigoRadio, QDistinct> {
  QueryBuilder<CodigoRadio, CodigoRadio, QDistinct> distinctByCodigo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'codigo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CodigoRadio, CodigoRadio, QDistinct> distinctBySignificado(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'significado', caseSensitive: caseSensitive);
    });
  }
}

extension CodigoRadioQueryProperty
    on QueryBuilder<CodigoRadio, CodigoRadio, QQueryProperty> {
  QueryBuilder<CodigoRadio, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CodigoRadio, String, QQueryOperations> codigoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codigo');
    });
  }

  QueryBuilder<CodigoRadio, String, QQueryOperations> significadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'significado');
    });
  }
}
