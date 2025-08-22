// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_hospital.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoriteHospital _$FavoriteHospitalFromJson(Map<String, dynamic> json) {
  return _FavoriteHospital.fromJson(json);
}

/// @nodoc
mixin _$FavoriteHospital {
  String get id => throw _privateConstructorUsedError;
  String get favoriteId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get hospitalId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  Map<String, dynamic>? get operatingHours =>
      throw _privateConstructorUsedError;
  List<String>? get departments => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get reviewCount => throw _privateConstructorUsedError;
  bool? get isEmergencyAvailable => throw _privateConstructorUsedError;
  bool? get isParkingAvailable => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime get favoritedAt => throw _privateConstructorUsedError;

  /// Serializes this FavoriteHospital to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteHospital
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteHospitalCopyWith<FavoriteHospital> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteHospitalCopyWith<$Res> {
  factory $FavoriteHospitalCopyWith(
          FavoriteHospital value, $Res Function(FavoriteHospital) then) =
      _$FavoriteHospitalCopyWithImpl<$Res, FavoriteHospital>;
  @useResult
  $Res call(
      {String id,
      String favoriteId,
      String userId,
      String hospitalId,
      String name,
      String address,
      String? phone,
      double latitude,
      double longitude,
      String? category,
      Map<String, dynamic>? operatingHours,
      List<String>? departments,
      double? rating,
      int? reviewCount,
      bool? isEmergencyAvailable,
      bool? isParkingAvailable,
      String? imageUrl,
      DateTime favoritedAt});
}

/// @nodoc
class _$FavoriteHospitalCopyWithImpl<$Res, $Val extends FavoriteHospital>
    implements $FavoriteHospitalCopyWith<$Res> {
  _$FavoriteHospitalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteHospital
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? favoriteId = null,
    Object? userId = null,
    Object? hospitalId = null,
    Object? name = null,
    Object? address = null,
    Object? phone = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? category = freezed,
    Object? operatingHours = freezed,
    Object? departments = freezed,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? isEmergencyAvailable = freezed,
    Object? isParkingAvailable = freezed,
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
      hospitalId: null == hospitalId
          ? _value.hospitalId
          : hospitalId // ignore: cast_nullable_to_non_nullable
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      operatingHours: freezed == operatingHours
          ? _value.operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      departments: freezed == departments
          ? _value.departments
          : departments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isEmergencyAvailable: freezed == isEmergencyAvailable
          ? _value.isEmergencyAvailable
          : isEmergencyAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isParkingAvailable: freezed == isParkingAvailable
          ? _value.isParkingAvailable
          : isParkingAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
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
abstract class _$$FavoriteHospitalImplCopyWith<$Res>
    implements $FavoriteHospitalCopyWith<$Res> {
  factory _$$FavoriteHospitalImplCopyWith(_$FavoriteHospitalImpl value,
          $Res Function(_$FavoriteHospitalImpl) then) =
      __$$FavoriteHospitalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String favoriteId,
      String userId,
      String hospitalId,
      String name,
      String address,
      String? phone,
      double latitude,
      double longitude,
      String? category,
      Map<String, dynamic>? operatingHours,
      List<String>? departments,
      double? rating,
      int? reviewCount,
      bool? isEmergencyAvailable,
      bool? isParkingAvailable,
      String? imageUrl,
      DateTime favoritedAt});
}

/// @nodoc
class __$$FavoriteHospitalImplCopyWithImpl<$Res>
    extends _$FavoriteHospitalCopyWithImpl<$Res, _$FavoriteHospitalImpl>
    implements _$$FavoriteHospitalImplCopyWith<$Res> {
  __$$FavoriteHospitalImplCopyWithImpl(_$FavoriteHospitalImpl _value,
      $Res Function(_$FavoriteHospitalImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoriteHospital
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? favoriteId = null,
    Object? userId = null,
    Object? hospitalId = null,
    Object? name = null,
    Object? address = null,
    Object? phone = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? category = freezed,
    Object? operatingHours = freezed,
    Object? departments = freezed,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? isEmergencyAvailable = freezed,
    Object? isParkingAvailable = freezed,
    Object? imageUrl = freezed,
    Object? favoritedAt = null,
  }) {
    return _then(_$FavoriteHospitalImpl(
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
      hospitalId: null == hospitalId
          ? _value.hospitalId
          : hospitalId // ignore: cast_nullable_to_non_nullable
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      operatingHours: freezed == operatingHours
          ? _value._operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      departments: freezed == departments
          ? _value._departments
          : departments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isEmergencyAvailable: freezed == isEmergencyAvailable
          ? _value.isEmergencyAvailable
          : isEmergencyAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isParkingAvailable: freezed == isParkingAvailable
          ? _value.isParkingAvailable
          : isParkingAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
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
class _$FavoriteHospitalImpl implements _FavoriteHospital {
  const _$FavoriteHospitalImpl(
      {required this.id,
      required this.favoriteId,
      required this.userId,
      required this.hospitalId,
      required this.name,
      required this.address,
      this.phone,
      required this.latitude,
      required this.longitude,
      this.category,
      final Map<String, dynamic>? operatingHours,
      final List<String>? departments,
      this.rating,
      this.reviewCount,
      this.isEmergencyAvailable,
      this.isParkingAvailable,
      this.imageUrl,
      required this.favoritedAt})
      : _operatingHours = operatingHours,
        _departments = departments;

  factory _$FavoriteHospitalImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteHospitalImplFromJson(json);

  @override
  final String id;
  @override
  final String favoriteId;
  @override
  final String userId;
  @override
  final String hospitalId;
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
  @override
  final String? category;
  final Map<String, dynamic>? _operatingHours;
  @override
  Map<String, dynamic>? get operatingHours {
    final value = _operatingHours;
    if (value == null) return null;
    if (_operatingHours is EqualUnmodifiableMapView) return _operatingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _departments;
  @override
  List<String>? get departments {
    final value = _departments;
    if (value == null) return null;
    if (_departments is EqualUnmodifiableListView) return _departments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? rating;
  @override
  final int? reviewCount;
  @override
  final bool? isEmergencyAvailable;
  @override
  final bool? isParkingAvailable;
  @override
  final String? imageUrl;
  @override
  final DateTime favoritedAt;

  @override
  String toString() {
    return 'FavoriteHospital(id: $id, favoriteId: $favoriteId, userId: $userId, hospitalId: $hospitalId, name: $name, address: $address, phone: $phone, latitude: $latitude, longitude: $longitude, category: $category, operatingHours: $operatingHours, departments: $departments, rating: $rating, reviewCount: $reviewCount, isEmergencyAvailable: $isEmergencyAvailable, isParkingAvailable: $isParkingAvailable, imageUrl: $imageUrl, favoritedAt: $favoritedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteHospitalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.favoriteId, favoriteId) ||
                other.favoriteId == favoriteId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.hospitalId, hospitalId) ||
                other.hospitalId == hospitalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._operatingHours, _operatingHours) &&
            const DeepCollectionEquality()
                .equals(other._departments, _departments) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isEmergencyAvailable, isEmergencyAvailable) ||
                other.isEmergencyAvailable == isEmergencyAvailable) &&
            (identical(other.isParkingAvailable, isParkingAvailable) ||
                other.isParkingAvailable == isParkingAvailable) &&
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
      hospitalId,
      name,
      address,
      phone,
      latitude,
      longitude,
      category,
      const DeepCollectionEquality().hash(_operatingHours),
      const DeepCollectionEquality().hash(_departments),
      rating,
      reviewCount,
      isEmergencyAvailable,
      isParkingAvailable,
      imageUrl,
      favoritedAt);

  /// Create a copy of FavoriteHospital
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteHospitalImplCopyWith<_$FavoriteHospitalImpl> get copyWith =>
      __$$FavoriteHospitalImplCopyWithImpl<_$FavoriteHospitalImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteHospitalImplToJson(
      this,
    );
  }
}

abstract class _FavoriteHospital implements FavoriteHospital {
  const factory _FavoriteHospital(
      {required final String id,
      required final String favoriteId,
      required final String userId,
      required final String hospitalId,
      required final String name,
      required final String address,
      final String? phone,
      required final double latitude,
      required final double longitude,
      final String? category,
      final Map<String, dynamic>? operatingHours,
      final List<String>? departments,
      final double? rating,
      final int? reviewCount,
      final bool? isEmergencyAvailable,
      final bool? isParkingAvailable,
      final String? imageUrl,
      required final DateTime favoritedAt}) = _$FavoriteHospitalImpl;

  factory _FavoriteHospital.fromJson(Map<String, dynamic> json) =
      _$FavoriteHospitalImpl.fromJson;

  @override
  String get id;
  @override
  String get favoriteId;
  @override
  String get userId;
  @override
  String get hospitalId;
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
  String? get category;
  @override
  Map<String, dynamic>? get operatingHours;
  @override
  List<String>? get departments;
  @override
  double? get rating;
  @override
  int? get reviewCount;
  @override
  bool? get isEmergencyAvailable;
  @override
  bool? get isParkingAvailable;
  @override
  String? get imageUrl;
  @override
  DateTime get favoritedAt;

  /// Create a copy of FavoriteHospital
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteHospitalImplCopyWith<_$FavoriteHospitalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
