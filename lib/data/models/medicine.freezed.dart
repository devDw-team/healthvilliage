// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Medicine _$MedicineFromJson(Map<String, dynamic> json) {
  return _Medicine.fromJson(json);
}

/// @nodoc
mixin _$Medicine {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get manufacturer => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get efficacy => throw _privateConstructorUsedError;
  String? get usage => throw _privateConstructorUsedError;
  String? get precautions => throw _privateConstructorUsedError;
  String? get interactions => throw _privateConstructorUsedError;
  String? get sideEffects => throw _privateConstructorUsedError;
  String? get storage => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // KFDA API 전용 필드
  String? get itemSeq => throw _privateConstructorUsedError; // 품목일련번호
  String? get itemPermitDate => throw _privateConstructorUsedError; // 품목허가일자
  String? get atpnWarnQesitm => throw _privateConstructorUsedError; // 주의사항경고
  String? get atpnQesitm => throw _privateConstructorUsedError; // 주의사항
  String? get openDe => throw _privateConstructorUsedError; // 공개일자
  String? get updateDe => throw _privateConstructorUsedError; // 수정일자
  String? get bizrno => throw _privateConstructorUsedError;

  /// Serializes this Medicine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineCopyWith<Medicine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineCopyWith<$Res> {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) then) =
      _$MedicineCopyWithImpl<$Res, Medicine>;
  @useResult
  $Res call(
      {String id,
      String name,
      String manufacturer,
      String? imageUrl,
      String? efficacy,
      String? usage,
      String? precautions,
      String? interactions,
      String? sideEffects,
      String? storage,
      bool isFavorite,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? itemSeq,
      String? itemPermitDate,
      String? atpnWarnQesitm,
      String? atpnQesitm,
      String? openDe,
      String? updateDe,
      String? bizrno});
}

/// @nodoc
class _$MedicineCopyWithImpl<$Res, $Val extends Medicine>
    implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? manufacturer = null,
    Object? imageUrl = freezed,
    Object? efficacy = freezed,
    Object? usage = freezed,
    Object? precautions = freezed,
    Object? interactions = freezed,
    Object? sideEffects = freezed,
    Object? storage = freezed,
    Object? isFavorite = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? itemSeq = freezed,
    Object? itemPermitDate = freezed,
    Object? atpnWarnQesitm = freezed,
    Object? atpnQesitm = freezed,
    Object? openDe = freezed,
    Object? updateDe = freezed,
    Object? bizrno = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      efficacy: freezed == efficacy
          ? _value.efficacy
          : efficacy // ignore: cast_nullable_to_non_nullable
              as String?,
      usage: freezed == usage
          ? _value.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as String?,
      precautions: freezed == precautions
          ? _value.precautions
          : precautions // ignore: cast_nullable_to_non_nullable
              as String?,
      interactions: freezed == interactions
          ? _value.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as String?,
      sideEffects: freezed == sideEffects
          ? _value.sideEffects
          : sideEffects // ignore: cast_nullable_to_non_nullable
              as String?,
      storage: freezed == storage
          ? _value.storage
          : storage // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemSeq: freezed == itemSeq
          ? _value.itemSeq
          : itemSeq // ignore: cast_nullable_to_non_nullable
              as String?,
      itemPermitDate: freezed == itemPermitDate
          ? _value.itemPermitDate
          : itemPermitDate // ignore: cast_nullable_to_non_nullable
              as String?,
      atpnWarnQesitm: freezed == atpnWarnQesitm
          ? _value.atpnWarnQesitm
          : atpnWarnQesitm // ignore: cast_nullable_to_non_nullable
              as String?,
      atpnQesitm: freezed == atpnQesitm
          ? _value.atpnQesitm
          : atpnQesitm // ignore: cast_nullable_to_non_nullable
              as String?,
      openDe: freezed == openDe
          ? _value.openDe
          : openDe // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDe: freezed == updateDe
          ? _value.updateDe
          : updateDe // ignore: cast_nullable_to_non_nullable
              as String?,
      bizrno: freezed == bizrno
          ? _value.bizrno
          : bizrno // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineImplCopyWith<$Res>
    implements $MedicineCopyWith<$Res> {
  factory _$$MedicineImplCopyWith(
          _$MedicineImpl value, $Res Function(_$MedicineImpl) then) =
      __$$MedicineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String manufacturer,
      String? imageUrl,
      String? efficacy,
      String? usage,
      String? precautions,
      String? interactions,
      String? sideEffects,
      String? storage,
      bool isFavorite,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? itemSeq,
      String? itemPermitDate,
      String? atpnWarnQesitm,
      String? atpnQesitm,
      String? openDe,
      String? updateDe,
      String? bizrno});
}

/// @nodoc
class __$$MedicineImplCopyWithImpl<$Res>
    extends _$MedicineCopyWithImpl<$Res, _$MedicineImpl>
    implements _$$MedicineImplCopyWith<$Res> {
  __$$MedicineImplCopyWithImpl(
      _$MedicineImpl _value, $Res Function(_$MedicineImpl) _then)
      : super(_value, _then);

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? manufacturer = null,
    Object? imageUrl = freezed,
    Object? efficacy = freezed,
    Object? usage = freezed,
    Object? precautions = freezed,
    Object? interactions = freezed,
    Object? sideEffects = freezed,
    Object? storage = freezed,
    Object? isFavorite = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? itemSeq = freezed,
    Object? itemPermitDate = freezed,
    Object? atpnWarnQesitm = freezed,
    Object? atpnQesitm = freezed,
    Object? openDe = freezed,
    Object? updateDe = freezed,
    Object? bizrno = freezed,
  }) {
    return _then(_$MedicineImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      efficacy: freezed == efficacy
          ? _value.efficacy
          : efficacy // ignore: cast_nullable_to_non_nullable
              as String?,
      usage: freezed == usage
          ? _value.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as String?,
      precautions: freezed == precautions
          ? _value.precautions
          : precautions // ignore: cast_nullable_to_non_nullable
              as String?,
      interactions: freezed == interactions
          ? _value.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as String?,
      sideEffects: freezed == sideEffects
          ? _value.sideEffects
          : sideEffects // ignore: cast_nullable_to_non_nullable
              as String?,
      storage: freezed == storage
          ? _value.storage
          : storage // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemSeq: freezed == itemSeq
          ? _value.itemSeq
          : itemSeq // ignore: cast_nullable_to_non_nullable
              as String?,
      itemPermitDate: freezed == itemPermitDate
          ? _value.itemPermitDate
          : itemPermitDate // ignore: cast_nullable_to_non_nullable
              as String?,
      atpnWarnQesitm: freezed == atpnWarnQesitm
          ? _value.atpnWarnQesitm
          : atpnWarnQesitm // ignore: cast_nullable_to_non_nullable
              as String?,
      atpnQesitm: freezed == atpnQesitm
          ? _value.atpnQesitm
          : atpnQesitm // ignore: cast_nullable_to_non_nullable
              as String?,
      openDe: freezed == openDe
          ? _value.openDe
          : openDe // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDe: freezed == updateDe
          ? _value.updateDe
          : updateDe // ignore: cast_nullable_to_non_nullable
              as String?,
      bizrno: freezed == bizrno
          ? _value.bizrno
          : bizrno // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicineImpl extends _Medicine {
  const _$MedicineImpl(
      {required this.id,
      required this.name,
      required this.manufacturer,
      this.imageUrl,
      this.efficacy,
      this.usage,
      this.precautions,
      this.interactions,
      this.sideEffects,
      this.storage,
      this.isFavorite = false,
      this.createdAt,
      this.updatedAt,
      this.itemSeq,
      this.itemPermitDate,
      this.atpnWarnQesitm,
      this.atpnQesitm,
      this.openDe,
      this.updateDe,
      this.bizrno})
      : super._();

  factory _$MedicineImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicineImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String manufacturer;
  @override
  final String? imageUrl;
  @override
  final String? efficacy;
  @override
  final String? usage;
  @override
  final String? precautions;
  @override
  final String? interactions;
  @override
  final String? sideEffects;
  @override
  final String? storage;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// KFDA API 전용 필드
  @override
  final String? itemSeq;
// 품목일련번호
  @override
  final String? itemPermitDate;
// 품목허가일자
  @override
  final String? atpnWarnQesitm;
// 주의사항경고
  @override
  final String? atpnQesitm;
// 주의사항
  @override
  final String? openDe;
// 공개일자
  @override
  final String? updateDe;
// 수정일자
  @override
  final String? bizrno;

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, manufacturer: $manufacturer, imageUrl: $imageUrl, efficacy: $efficacy, usage: $usage, precautions: $precautions, interactions: $interactions, sideEffects: $sideEffects, storage: $storage, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt, itemSeq: $itemSeq, itemPermitDate: $itemPermitDate, atpnWarnQesitm: $atpnWarnQesitm, atpnQesitm: $atpnQesitm, openDe: $openDe, updateDe: $updateDe, bizrno: $bizrno)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.efficacy, efficacy) ||
                other.efficacy == efficacy) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.precautions, precautions) ||
                other.precautions == precautions) &&
            (identical(other.interactions, interactions) ||
                other.interactions == interactions) &&
            (identical(other.sideEffects, sideEffects) ||
                other.sideEffects == sideEffects) &&
            (identical(other.storage, storage) || other.storage == storage) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.itemSeq, itemSeq) || other.itemSeq == itemSeq) &&
            (identical(other.itemPermitDate, itemPermitDate) ||
                other.itemPermitDate == itemPermitDate) &&
            (identical(other.atpnWarnQesitm, atpnWarnQesitm) ||
                other.atpnWarnQesitm == atpnWarnQesitm) &&
            (identical(other.atpnQesitm, atpnQesitm) ||
                other.atpnQesitm == atpnQesitm) &&
            (identical(other.openDe, openDe) || other.openDe == openDe) &&
            (identical(other.updateDe, updateDe) ||
                other.updateDe == updateDe) &&
            (identical(other.bizrno, bizrno) || other.bizrno == bizrno));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        manufacturer,
        imageUrl,
        efficacy,
        usage,
        precautions,
        interactions,
        sideEffects,
        storage,
        isFavorite,
        createdAt,
        updatedAt,
        itemSeq,
        itemPermitDate,
        atpnWarnQesitm,
        atpnQesitm,
        openDe,
        updateDe,
        bizrno
      ]);

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineImplCopyWith<_$MedicineImpl> get copyWith =>
      __$$MedicineImplCopyWithImpl<_$MedicineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineImplToJson(
      this,
    );
  }
}

abstract class _Medicine extends Medicine {
  const factory _Medicine(
      {required final String id,
      required final String name,
      required final String manufacturer,
      final String? imageUrl,
      final String? efficacy,
      final String? usage,
      final String? precautions,
      final String? interactions,
      final String? sideEffects,
      final String? storage,
      final bool isFavorite,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? itemSeq,
      final String? itemPermitDate,
      final String? atpnWarnQesitm,
      final String? atpnQesitm,
      final String? openDe,
      final String? updateDe,
      final String? bizrno}) = _$MedicineImpl;
  const _Medicine._() : super._();

  factory _Medicine.fromJson(Map<String, dynamic> json) =
      _$MedicineImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get manufacturer;
  @override
  String? get imageUrl;
  @override
  String? get efficacy;
  @override
  String? get usage;
  @override
  String? get precautions;
  @override
  String? get interactions;
  @override
  String? get sideEffects;
  @override
  String? get storage;
  @override
  bool get isFavorite;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // KFDA API 전용 필드
  @override
  String? get itemSeq; // 품목일련번호
  @override
  String? get itemPermitDate; // 품목허가일자
  @override
  String? get atpnWarnQesitm; // 주의사항경고
  @override
  String? get atpnQesitm; // 주의사항
  @override
  String? get openDe; // 공개일자
  @override
  String? get updateDe; // 수정일자
  @override
  String? get bizrno;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineImplCopyWith<_$MedicineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
