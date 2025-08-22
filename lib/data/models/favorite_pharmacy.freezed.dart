// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_pharmacy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoritePharmacy _$FavoritePharmacyFromJson(Map<String, dynamic> json) {
  return _FavoritePharmacy.fromJson(json);
}

/// @nodoc
mixin _$FavoritePharmacy {
  String get id => throw _privateConstructorUsedError;
  String get favoriteId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get pharmacyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  Map<String, dynamic>? get operatingHours =>
      throw _privateConstructorUsedError;
  bool? get isNightPharmacy => throw _privateConstructorUsedError;
  bool? get isHolidayOpen => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get reviewCount => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime get favoritedAt => throw _privateConstructorUsedError;

  /// Serializes this FavoritePharmacy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoritePharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoritePharmacyCopyWith<FavoritePharmacy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritePharmacyCopyWith<$Res> {
  factory $FavoritePharmacyCopyWith(
          FavoritePharmacy value, $Res Function(FavoritePharmacy) then) =
      _$FavoritePharmacyCopyWithImpl<$Res, FavoritePharmacy>;
  @useResult
  $Res call(
      {String id,
      String favoriteId,
      String userId,
      String pharmacyId,
      String name,
      String address,
      String? phone,
      double latitude,
      double longitude,
      Map<String, dynamic>? operatingHours,
      bool? isNightPharmacy,
      bool? isHolidayOpen,
      double? rating,
      int? reviewCount,
      String? imageUrl,
      DateTime favoritedAt});
}

/// @nodoc
class _$FavoritePharmacyCopyWithImpl<$Res, $Val extends FavoritePharmacy>
    implements $FavoritePharmacyCopyWith<$Res> {
  _$FavoritePharmacyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritePharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? favoriteId = null,
    Object? userId = null,
    Object? pharmacyId = null,
    Object? name = null,
    Object? address = null,
    Object? phone = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? operatingHours = freezed,
    Object? isNightPharmacy = freezed,
    Object? isHolidayOpen = freezed,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? imageUrl = freezed,
    Object? favoritedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      favoriteId: null == favoriteId
          ? _value.favoriteId
          : favoriteId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pharmacyId: null == pharmacyId
          ? _value.pharmacyId
          : pharmacyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      operatingHours: freezed == operatingHours
          ? _value.operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isNightPharmacy: freezed == isNightPharmacy
          ? _value.isNightPharmacy
          : isNightPharmacy // ignore: cast_nullable_to_non_nullable
              as bool?,
      isHolidayOpen: freezed == isHolidayOpen
          ? _value.isHolidayOpen
          : isHolidayOpen // ignore: cast_nullable_to_non_nullable
              as bool?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      favoritedAt: null == favoritedAt
          ? _value.favoritedAt
          : favoritedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoritePharmacyImplCopyWith<$Res>
    implements $FavoritePharmacyCopyWith<$Res> {
  factory _$$FavoritePharmacyImplCopyWith(_$FavoritePharmacyImpl value,
          $Res Function(_$FavoritePharmacyImpl) then) =
      __$$FavoritePharmacyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String favoriteId,
      String userId,
      String pharmacyId,
      String name,
      String address,
      String? phone,
      double latitude,
      double longitude,
      Map<String, dynamic>? operatingHours,
      bool? isNightPharmacy,
      bool? isHolidayOpen,
      double? rating,
      int? reviewCount,
      String? imageUrl,
      DateTime favoritedAt});
}

/// @nodoc
class __$$FavoritePharmacyImplCopyWithImpl<$Res>
    extends _$FavoritePharmacyCopyWithImpl<$Res, _$FavoritePharmacyImpl>
    implements _$$FavoritePharmacyImplCopyWith<$Res> {
  __$$FavoritePharmacyImplCopyWithImpl(_$FavoritePharmacyImpl _value,
      $Res Function(_$FavoritePharmacyImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoritePharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? favoriteId = null,
    Object? userId = null,
    Object? pharmacyId = null,
    Object? name = null,
    Object? address = null,
    Object? phone = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? operatingHours = freezed,
    Object? isNightPharmacy = freezed,
    Object? isHolidayOpen = freezed,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? imageUrl = freezed,
    Object? favoritedAt = null,
  }) {
    return _then(_$FavoritePharmacyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      favoriteId: null == favoriteId
          ? _value.favoriteId
          : favoriteId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pharmacyId: null == pharmacyId
          ? _value.pharmacyId
          : pharmacyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      operatingHours: freezed == operatingHours
          ? _value._operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isNightPharmacy: freezed == isNightPharmacy
          ? _value.isNightPharmacy
          : isNightPharmacy // ignore: cast_nullable_to_non_nullable
              as bool?,
      isHolidayOpen: freezed == isHolidayOpen
          ? _value.isHolidayOpen
          : isHolidayOpen // ignore: cast_nullable_to_non_nullable
              as bool?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      favoritedAt: null == favoritedAt
          ? _value.favoritedAt
          : favoritedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoritePharmacyImpl implements _FavoritePharmacy {
  const _$FavoritePharmacyImpl(
      {required this.id,
      required this.favoriteId,
      required this.userId,
      required this.pharmacyId,
      required this.name,
      required this.address,
      this.phone,
      required this.latitude,
      required this.longitude,
      final Map<String, dynamic>? operatingHours,
      this.isNightPharmacy,
      this.isHolidayOpen,
      this.rating,
      this.reviewCount,
      this.imageUrl,
      required this.favoritedAt})
      : _operatingHours = operatingHours;

  factory _$FavoritePharmacyImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoritePharmacyImplFromJson(json);

  @override
  final String id;
  @override
  final String favoriteId;
  @override
  final String userId;
  @override
  final String pharmacyId;
  @override
  final String name;
  @override
  final String address;
  @override
  final String? phone;
  @override
  final double latitude;
  @override
  final double longitude;
  final Map<String, dynamic>? _operatingHours;
  @override
  Map<String, dynamic>? get operatingHours {
    final value = _operatingHours;
    if (value == null) return null;
    if (_operatingHours is EqualUnmodifiableMapView) return _operatingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isNightPharmacy;
  @override
  final bool? isHolidayOpen;
  @override
  final double? rating;
  @override
  final int? reviewCount;
  @override
  final String? imageUrl;
  @override
  final DateTime favoritedAt;

  @override
  String toString() {
    return 'FavoritePharmacy(id: $id, favoriteId: $favoriteId, userId: $userId, pharmacyId: $pharmacyId, name: $name, address: $address, phone: $phone, latitude: $latitude, longitude: $longitude, operatingHours: $operatingHours, isNightPharmacy: $isNightPharmacy, isHolidayOpen: $isHolidayOpen, rating: $rating, reviewCount: $reviewCount, imageUrl: $imageUrl, favoritedAt: $favoritedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritePharmacyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.favoriteId, favoriteId) ||
                other.favoriteId == favoriteId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pharmacyId, pharmacyId) ||
                other.pharmacyId == pharmacyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality()
                .equals(other._operatingHours, _operatingHours) &&
            (identical(other.isNightPharmacy, isNightPharmacy) ||
                other.isNightPharmacy == isNightPharmacy) &&
            (identical(other.isHolidayOpen, isHolidayOpen) ||
                other.isHolidayOpen == isHolidayOpen) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.favoritedAt, favoritedAt) ||
                other.favoritedAt == favoritedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      favoriteId,
      userId,
      pharmacyId,
      name,
      address,
      phone,
      latitude,
      longitude,
      const DeepCollectionEquality().hash(_operatingHours),
      isNightPharmacy,
      isHolidayOpen,
      rating,
      reviewCount,
      imageUrl,
      favoritedAt);

  /// Create a copy of FavoritePharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritePharmacyImplCopyWith<_$FavoritePharmacyImpl> get copyWith =>
      __$$FavoritePharmacyImplCopyWithImpl<_$FavoritePharmacyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoritePharmacyImplToJson(
      this,
    );
  }
}

abstract class _FavoritePharmacy implements FavoritePharmacy {
  const factory _FavoritePharmacy(
      {required final String id,
      required final String favoriteId,
      required final String userId,
      required final String pharmacyId,
      required final String name,
      required final String address,
      final String? phone,
      required final double latitude,
      required final double longitude,
      final Map<String, dynamic>? operatingHours,
      final bool? isNightPharmacy,
      final bool? isHolidayOpen,
      final double? rating,
      final int? reviewCount,
      final String? imageUrl,
      required final DateTime favoritedAt}) = _$FavoritePharmacyImpl;

  factory _FavoritePharmacy.fromJson(Map<String, dynamic> json) =
      _$FavoritePharmacyImpl.fromJson;

  @override
  String get id;
  @override
  String get favoriteId;
  @override
  String get userId;
  @override
  String get pharmacyId;
  @override
  String get name;
  @override
  String get address;
  @override
  String? get phone;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  Map<String, dynamic>? get operatingHours;
  @override
  bool? get isNightPharmacy;
  @override
  bool? get isHolidayOpen;
  @override
  double? get rating;
  @override
  int? get reviewCount;
  @override
  String? get imageUrl;
  @override
  DateTime get favoritedAt;

  /// Create a copy of FavoritePharmacy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritePharmacyImplCopyWith<_$FavoritePharmacyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
