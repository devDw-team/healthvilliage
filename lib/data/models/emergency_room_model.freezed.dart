// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmergencyRoom _$EmergencyRoomFromJson(Map<String, dynamic> json) {
  return _EmergencyRoom.fromJson(json);
}

/// @nodoc
mixin _$EmergencyRoom {
  @JsonKey(name: 'hpid')
  String get hpid => throw _privateConstructorUsedError; // 기관ID
  @JsonKey(name: 'dutyName')
  String get dutyName => throw _privateConstructorUsedError; // 기관명
  @JsonKey(name: 'dutyAddr')
  String? get dutyAddr =>
      throw _privateConstructorUsedError; // 주소 (가용병상정보 조회시 없을 수 있음)
  @JsonKey(name: 'dutyTel1')
  String? get dutyTel1 => throw _privateConstructorUsedError; // 대표전화
  @JsonKey(name: 'dutyTel3')
  String? get dutyTel3 => throw _privateConstructorUsedError; // 응급실전화
  @JsonKey(name: 'wgs84Lon')
  String? get longitude => throw _privateConstructorUsedError; // 병원경도
  @JsonKey(name: 'wgs84Lat')
  String? get latitude => throw _privateConstructorUsedError; // 병원위도
  @JsonKey(name: 'dutyEmcls')
  String? get dutyEmcls => throw _privateConstructorUsedError; // 응급의료기관분류
  @JsonKey(name: 'dutyEmclsName')
  String? get dutyEmclsName => throw _privateConstructorUsedError; // 응급의료기관분류명
  @JsonKey(name: 'distance')
  double? get distance => throw _privateConstructorUsedError; // 거리 (위치기반 검색 시)
// 가용병상정보
  @JsonKey(name: 'hvec')
  int? get availableGeneralBeds =>
      throw _privateConstructorUsedError; // 응급실 일반병상
  @JsonKey(name: 'hvoc')
  int? get availableOperatingRooms => throw _privateConstructorUsedError; // 수술실
  @JsonKey(name: 'hvcc')
  int? get availableNeuroICU => throw _privateConstructorUsedError; // 신경중환자실
  @JsonKey(name: 'hvncc')
  int? get availableNeonatalICU =>
      throw _privateConstructorUsedError; // 신생아중환자실
  @JsonKey(name: 'hvccc')
  int? get availableChestICU => throw _privateConstructorUsedError; // 흉부중환자실
  @JsonKey(name: 'hvicc')
  int? get availableGeneralICU => throw _privateConstructorUsedError; // 일반중환자실
  @JsonKey(name: 'hvgc')
  int? get availableAdmissionRooms => throw _privateConstructorUsedError; // 입원실
// 가용여부
  @JsonKey(name: 'hvctayn')
  String? get ctAvailable => throw _privateConstructorUsedError; // CT가용여부 (Y/N)
  @JsonKey(name: 'hvmriayn')
  String? get mriAvailable =>
      throw _privateConstructorUsedError; // MRI가용여부 (Y/N)
  @JsonKey(name: 'hvamyn')
  String? get ambulanceAvailable =>
      throw _privateConstructorUsedError; // 구급차가용여부 (Y/N)
// 진료시간
  @JsonKey(name: 'dutyTime1s')
  String? get mondayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime1c')
  String? get mondayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime2s')
  String? get tuesdayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime2c')
  String? get tuesdayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime3s')
  String? get wednesdayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime3c')
  String? get wednesdayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime4s')
  String? get thursdayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime4c')
  String? get thursdayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime5s')
  String? get fridayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime5c')
  String? get fridayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime6s')
  String? get saturdayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime6c')
  String? get saturdayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime7s')
  String? get sundayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime7c')
  String? get sundayEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime8s')
  String? get holidayStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'dutyTime8c')
  String? get holidayEnd => throw _privateConstructorUsedError;

  /// Serializes this EmergencyRoom to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmergencyRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergencyRoomCopyWith<EmergencyRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyRoomCopyWith<$Res> {
  factory $EmergencyRoomCopyWith(
          EmergencyRoom value, $Res Function(EmergencyRoom) then) =
      _$EmergencyRoomCopyWithImpl<$Res, EmergencyRoom>;
  @useResult
  $Res call(
      {@JsonKey(name: 'hpid') String hpid,
      @JsonKey(name: 'dutyName') String dutyName,
      @JsonKey(name: 'dutyAddr') String? dutyAddr,
      @JsonKey(name: 'dutyTel1') String? dutyTel1,
      @JsonKey(name: 'dutyTel3') String? dutyTel3,
      @JsonKey(name: 'wgs84Lon') String? longitude,
      @JsonKey(name: 'wgs84Lat') String? latitude,
      @JsonKey(name: 'dutyEmcls') String? dutyEmcls,
      @JsonKey(name: 'dutyEmclsName') String? dutyEmclsName,
      @JsonKey(name: 'distance') double? distance,
      @JsonKey(name: 'hvec') int? availableGeneralBeds,
      @JsonKey(name: 'hvoc') int? availableOperatingRooms,
      @JsonKey(name: 'hvcc') int? availableNeuroICU,
      @JsonKey(name: 'hvncc') int? availableNeonatalICU,
      @JsonKey(name: 'hvccc') int? availableChestICU,
      @JsonKey(name: 'hvicc') int? availableGeneralICU,
      @JsonKey(name: 'hvgc') int? availableAdmissionRooms,
      @JsonKey(name: 'hvctayn') String? ctAvailable,
      @JsonKey(name: 'hvmriayn') String? mriAvailable,
      @JsonKey(name: 'hvamyn') String? ambulanceAvailable,
      @JsonKey(name: 'dutyTime1s') String? mondayStart,
      @JsonKey(name: 'dutyTime1c') String? mondayEnd,
      @JsonKey(name: 'dutyTime2s') String? tuesdayStart,
      @JsonKey(name: 'dutyTime2c') String? tuesdayEnd,
      @JsonKey(name: 'dutyTime3s') String? wednesdayStart,
      @JsonKey(name: 'dutyTime3c') String? wednesdayEnd,
      @JsonKey(name: 'dutyTime4s') String? thursdayStart,
      @JsonKey(name: 'dutyTime4c') String? thursdayEnd,
      @JsonKey(name: 'dutyTime5s') String? fridayStart,
      @JsonKey(name: 'dutyTime5c') String? fridayEnd,
      @JsonKey(name: 'dutyTime6s') String? saturdayStart,
      @JsonKey(name: 'dutyTime6c') String? saturdayEnd,
      @JsonKey(name: 'dutyTime7s') String? sundayStart,
      @JsonKey(name: 'dutyTime7c') String? sundayEnd,
      @JsonKey(name: 'dutyTime8s') String? holidayStart,
      @JsonKey(name: 'dutyTime8c') String? holidayEnd});
}

/// @nodoc
class _$EmergencyRoomCopyWithImpl<$Res, $Val extends EmergencyRoom>
    implements $EmergencyRoomCopyWith<$Res> {
  _$EmergencyRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergencyRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hpid = null,
    Object? dutyName = null,
    Object? dutyAddr = freezed,
    Object? dutyTel1 = freezed,
    Object? dutyTel3 = freezed,
    Object? longitude = freezed,
    Object? latitude = freezed,
    Object? dutyEmcls = freezed,
    Object? dutyEmclsName = freezed,
    Object? distance = freezed,
    Object? availableGeneralBeds = freezed,
    Object? availableOperatingRooms = freezed,
    Object? availableNeuroICU = freezed,
    Object? availableNeonatalICU = freezed,
    Object? availableChestICU = freezed,
    Object? availableGeneralICU = freezed,
    Object? availableAdmissionRooms = freezed,
    Object? ctAvailable = freezed,
    Object? mriAvailable = freezed,
    Object? ambulanceAvailable = freezed,
    Object? mondayStart = freezed,
    Object? mondayEnd = freezed,
    Object? tuesdayStart = freezed,
    Object? tuesdayEnd = freezed,
    Object? wednesdayStart = freezed,
    Object? wednesdayEnd = freezed,
    Object? thursdayStart = freezed,
    Object? thursdayEnd = freezed,
    Object? fridayStart = freezed,
    Object? fridayEnd = freezed,
    Object? saturdayStart = freezed,
    Object? saturdayEnd = freezed,
    Object? sundayStart = freezed,
    Object? sundayEnd = freezed,
    Object? holidayStart = freezed,
    Object? holidayEnd = freezed,
  }) {
    return _then(_value.copyWith(
      hpid: null == hpid
          ? _value.hpid
          : hpid // ignore: cast_nullable_to_non_nullable
              as String,
      dutyName: null == dutyName
          ? _value.dutyName
          : dutyName // ignore: cast_nullable_to_non_nullable
              as String,
      dutyAddr: freezed == dutyAddr
          ? _value.dutyAddr
          : dutyAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyTel1: freezed == dutyTel1
          ? _value.dutyTel1
          : dutyTel1 // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyTel3: freezed == dutyTel3
          ? _value.dutyTel3
          : dutyTel3 // ignore: cast_nullable_to_non_nullable
              as String?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyEmcls: freezed == dutyEmcls
          ? _value.dutyEmcls
          : dutyEmcls // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyEmclsName: freezed == dutyEmclsName
          ? _value.dutyEmclsName
          : dutyEmclsName // ignore: cast_nullable_to_non_nullable
              as String?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      availableGeneralBeds: freezed == availableGeneralBeds
          ? _value.availableGeneralBeds
          : availableGeneralBeds // ignore: cast_nullable_to_non_nullable
              as int?,
      availableOperatingRooms: freezed == availableOperatingRooms
          ? _value.availableOperatingRooms
          : availableOperatingRooms // ignore: cast_nullable_to_non_nullable
              as int?,
      availableNeuroICU: freezed == availableNeuroICU
          ? _value.availableNeuroICU
          : availableNeuroICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableNeonatalICU: freezed == availableNeonatalICU
          ? _value.availableNeonatalICU
          : availableNeonatalICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableChestICU: freezed == availableChestICU
          ? _value.availableChestICU
          : availableChestICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableGeneralICU: freezed == availableGeneralICU
          ? _value.availableGeneralICU
          : availableGeneralICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableAdmissionRooms: freezed == availableAdmissionRooms
          ? _value.availableAdmissionRooms
          : availableAdmissionRooms // ignore: cast_nullable_to_non_nullable
              as int?,
      ctAvailable: freezed == ctAvailable
          ? _value.ctAvailable
          : ctAvailable // ignore: cast_nullable_to_non_nullable
              as String?,
      mriAvailable: freezed == mriAvailable
          ? _value.mriAvailable
          : mriAvailable // ignore: cast_nullable_to_non_nullable
              as String?,
      ambulanceAvailable: freezed == ambulanceAvailable
          ? _value.ambulanceAvailable
          : ambulanceAvailable // ignore: cast_nullable_to_non_nullable
              as String?,
      mondayStart: freezed == mondayStart
          ? _value.mondayStart
          : mondayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      mondayEnd: freezed == mondayEnd
          ? _value.mondayEnd
          : mondayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      tuesdayStart: freezed == tuesdayStart
          ? _value.tuesdayStart
          : tuesdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      tuesdayEnd: freezed == tuesdayEnd
          ? _value.tuesdayEnd
          : tuesdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      wednesdayStart: freezed == wednesdayStart
          ? _value.wednesdayStart
          : wednesdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      wednesdayEnd: freezed == wednesdayEnd
          ? _value.wednesdayEnd
          : wednesdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      thursdayStart: freezed == thursdayStart
          ? _value.thursdayStart
          : thursdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      thursdayEnd: freezed == thursdayEnd
          ? _value.thursdayEnd
          : thursdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      fridayStart: freezed == fridayStart
          ? _value.fridayStart
          : fridayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      fridayEnd: freezed == fridayEnd
          ? _value.fridayEnd
          : fridayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      saturdayStart: freezed == saturdayStart
          ? _value.saturdayStart
          : saturdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      saturdayEnd: freezed == saturdayEnd
          ? _value.saturdayEnd
          : saturdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      sundayStart: freezed == sundayStart
          ? _value.sundayStart
          : sundayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      sundayEnd: freezed == sundayEnd
          ? _value.sundayEnd
          : sundayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      holidayStart: freezed == holidayStart
          ? _value.holidayStart
          : holidayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      holidayEnd: freezed == holidayEnd
          ? _value.holidayEnd
          : holidayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmergencyRoomImplCopyWith<$Res>
    implements $EmergencyRoomCopyWith<$Res> {
  factory _$$EmergencyRoomImplCopyWith(
          _$EmergencyRoomImpl value, $Res Function(_$EmergencyRoomImpl) then) =
      __$$EmergencyRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'hpid') String hpid,
      @JsonKey(name: 'dutyName') String dutyName,
      @JsonKey(name: 'dutyAddr') String? dutyAddr,
      @JsonKey(name: 'dutyTel1') String? dutyTel1,
      @JsonKey(name: 'dutyTel3') String? dutyTel3,
      @JsonKey(name: 'wgs84Lon') String? longitude,
      @JsonKey(name: 'wgs84Lat') String? latitude,
      @JsonKey(name: 'dutyEmcls') String? dutyEmcls,
      @JsonKey(name: 'dutyEmclsName') String? dutyEmclsName,
      @JsonKey(name: 'distance') double? distance,
      @JsonKey(name: 'hvec') int? availableGeneralBeds,
      @JsonKey(name: 'hvoc') int? availableOperatingRooms,
      @JsonKey(name: 'hvcc') int? availableNeuroICU,
      @JsonKey(name: 'hvncc') int? availableNeonatalICU,
      @JsonKey(name: 'hvccc') int? availableChestICU,
      @JsonKey(name: 'hvicc') int? availableGeneralICU,
      @JsonKey(name: 'hvgc') int? availableAdmissionRooms,
      @JsonKey(name: 'hvctayn') String? ctAvailable,
      @JsonKey(name: 'hvmriayn') String? mriAvailable,
      @JsonKey(name: 'hvamyn') String? ambulanceAvailable,
      @JsonKey(name: 'dutyTime1s') String? mondayStart,
      @JsonKey(name: 'dutyTime1c') String? mondayEnd,
      @JsonKey(name: 'dutyTime2s') String? tuesdayStart,
      @JsonKey(name: 'dutyTime2c') String? tuesdayEnd,
      @JsonKey(name: 'dutyTime3s') String? wednesdayStart,
      @JsonKey(name: 'dutyTime3c') String? wednesdayEnd,
      @JsonKey(name: 'dutyTime4s') String? thursdayStart,
      @JsonKey(name: 'dutyTime4c') String? thursdayEnd,
      @JsonKey(name: 'dutyTime5s') String? fridayStart,
      @JsonKey(name: 'dutyTime5c') String? fridayEnd,
      @JsonKey(name: 'dutyTime6s') String? saturdayStart,
      @JsonKey(name: 'dutyTime6c') String? saturdayEnd,
      @JsonKey(name: 'dutyTime7s') String? sundayStart,
      @JsonKey(name: 'dutyTime7c') String? sundayEnd,
      @JsonKey(name: 'dutyTime8s') String? holidayStart,
      @JsonKey(name: 'dutyTime8c') String? holidayEnd});
}

/// @nodoc
class __$$EmergencyRoomImplCopyWithImpl<$Res>
    extends _$EmergencyRoomCopyWithImpl<$Res, _$EmergencyRoomImpl>
    implements _$$EmergencyRoomImplCopyWith<$Res> {
  __$$EmergencyRoomImplCopyWithImpl(
      _$EmergencyRoomImpl _value, $Res Function(_$EmergencyRoomImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmergencyRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hpid = null,
    Object? dutyName = null,
    Object? dutyAddr = freezed,
    Object? dutyTel1 = freezed,
    Object? dutyTel3 = freezed,
    Object? longitude = freezed,
    Object? latitude = freezed,
    Object? dutyEmcls = freezed,
    Object? dutyEmclsName = freezed,
    Object? distance = freezed,
    Object? availableGeneralBeds = freezed,
    Object? availableOperatingRooms = freezed,
    Object? availableNeuroICU = freezed,
    Object? availableNeonatalICU = freezed,
    Object? availableChestICU = freezed,
    Object? availableGeneralICU = freezed,
    Object? availableAdmissionRooms = freezed,
    Object? ctAvailable = freezed,
    Object? mriAvailable = freezed,
    Object? ambulanceAvailable = freezed,
    Object? mondayStart = freezed,
    Object? mondayEnd = freezed,
    Object? tuesdayStart = freezed,
    Object? tuesdayEnd = freezed,
    Object? wednesdayStart = freezed,
    Object? wednesdayEnd = freezed,
    Object? thursdayStart = freezed,
    Object? thursdayEnd = freezed,
    Object? fridayStart = freezed,
    Object? fridayEnd = freezed,
    Object? saturdayStart = freezed,
    Object? saturdayEnd = freezed,
    Object? sundayStart = freezed,
    Object? sundayEnd = freezed,
    Object? holidayStart = freezed,
    Object? holidayEnd = freezed,
  }) {
    return _then(_$EmergencyRoomImpl(
      hpid: null == hpid
          ? _value.hpid
          : hpid // ignore: cast_nullable_to_non_nullable
              as String,
      dutyName: null == dutyName
          ? _value.dutyName
          : dutyName // ignore: cast_nullable_to_non_nullable
              as String,
      dutyAddr: freezed == dutyAddr
          ? _value.dutyAddr
          : dutyAddr // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyTel1: freezed == dutyTel1
          ? _value.dutyTel1
          : dutyTel1 // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyTel3: freezed == dutyTel3
          ? _value.dutyTel3
          : dutyTel3 // ignore: cast_nullable_to_non_nullable
              as String?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyEmcls: freezed == dutyEmcls
          ? _value.dutyEmcls
          : dutyEmcls // ignore: cast_nullable_to_non_nullable
              as String?,
      dutyEmclsName: freezed == dutyEmclsName
          ? _value.dutyEmclsName
          : dutyEmclsName // ignore: cast_nullable_to_non_nullable
              as String?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      availableGeneralBeds: freezed == availableGeneralBeds
          ? _value.availableGeneralBeds
          : availableGeneralBeds // ignore: cast_nullable_to_non_nullable
              as int?,
      availableOperatingRooms: freezed == availableOperatingRooms
          ? _value.availableOperatingRooms
          : availableOperatingRooms // ignore: cast_nullable_to_non_nullable
              as int?,
      availableNeuroICU: freezed == availableNeuroICU
          ? _value.availableNeuroICU
          : availableNeuroICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableNeonatalICU: freezed == availableNeonatalICU
          ? _value.availableNeonatalICU
          : availableNeonatalICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableChestICU: freezed == availableChestICU
          ? _value.availableChestICU
          : availableChestICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableGeneralICU: freezed == availableGeneralICU
          ? _value.availableGeneralICU
          : availableGeneralICU // ignore: cast_nullable_to_non_nullable
              as int?,
      availableAdmissionRooms: freezed == availableAdmissionRooms
          ? _value.availableAdmissionRooms
          : availableAdmissionRooms // ignore: cast_nullable_to_non_nullable
              as int?,
      ctAvailable: freezed == ctAvailable
          ? _value.ctAvailable
          : ctAvailable // ignore: cast_nullable_to_non_nullable
              as String?,
      mriAvailable: freezed == mriAvailable
          ? _value.mriAvailable
          : mriAvailable // ignore: cast_nullable_to_non_nullable
              as String?,
      ambulanceAvailable: freezed == ambulanceAvailable
          ? _value.ambulanceAvailable
          : ambulanceAvailable // ignore: cast_nullable_to_non_nullable
              as String?,
      mondayStart: freezed == mondayStart
          ? _value.mondayStart
          : mondayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      mondayEnd: freezed == mondayEnd
          ? _value.mondayEnd
          : mondayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      tuesdayStart: freezed == tuesdayStart
          ? _value.tuesdayStart
          : tuesdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      tuesdayEnd: freezed == tuesdayEnd
          ? _value.tuesdayEnd
          : tuesdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      wednesdayStart: freezed == wednesdayStart
          ? _value.wednesdayStart
          : wednesdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      wednesdayEnd: freezed == wednesdayEnd
          ? _value.wednesdayEnd
          : wednesdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      thursdayStart: freezed == thursdayStart
          ? _value.thursdayStart
          : thursdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      thursdayEnd: freezed == thursdayEnd
          ? _value.thursdayEnd
          : thursdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      fridayStart: freezed == fridayStart
          ? _value.fridayStart
          : fridayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      fridayEnd: freezed == fridayEnd
          ? _value.fridayEnd
          : fridayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      saturdayStart: freezed == saturdayStart
          ? _value.saturdayStart
          : saturdayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      saturdayEnd: freezed == saturdayEnd
          ? _value.saturdayEnd
          : saturdayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      sundayStart: freezed == sundayStart
          ? _value.sundayStart
          : sundayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      sundayEnd: freezed == sundayEnd
          ? _value.sundayEnd
          : sundayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      holidayStart: freezed == holidayStart
          ? _value.holidayStart
          : holidayStart // ignore: cast_nullable_to_non_nullable
              as String?,
      holidayEnd: freezed == holidayEnd
          ? _value.holidayEnd
          : holidayEnd // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyRoomImpl extends _EmergencyRoom {
  const _$EmergencyRoomImpl(
      {@JsonKey(name: 'hpid') required this.hpid,
      @JsonKey(name: 'dutyName') required this.dutyName,
      @JsonKey(name: 'dutyAddr') this.dutyAddr,
      @JsonKey(name: 'dutyTel1') this.dutyTel1,
      @JsonKey(name: 'dutyTel3') this.dutyTel3,
      @JsonKey(name: 'wgs84Lon') this.longitude,
      @JsonKey(name: 'wgs84Lat') this.latitude,
      @JsonKey(name: 'dutyEmcls') this.dutyEmcls,
      @JsonKey(name: 'dutyEmclsName') this.dutyEmclsName,
      @JsonKey(name: 'distance') this.distance,
      @JsonKey(name: 'hvec') this.availableGeneralBeds,
      @JsonKey(name: 'hvoc') this.availableOperatingRooms,
      @JsonKey(name: 'hvcc') this.availableNeuroICU,
      @JsonKey(name: 'hvncc') this.availableNeonatalICU,
      @JsonKey(name: 'hvccc') this.availableChestICU,
      @JsonKey(name: 'hvicc') this.availableGeneralICU,
      @JsonKey(name: 'hvgc') this.availableAdmissionRooms,
      @JsonKey(name: 'hvctayn') this.ctAvailable,
      @JsonKey(name: 'hvmriayn') this.mriAvailable,
      @JsonKey(name: 'hvamyn') this.ambulanceAvailable,
      @JsonKey(name: 'dutyTime1s') this.mondayStart,
      @JsonKey(name: 'dutyTime1c') this.mondayEnd,
      @JsonKey(name: 'dutyTime2s') this.tuesdayStart,
      @JsonKey(name: 'dutyTime2c') this.tuesdayEnd,
      @JsonKey(name: 'dutyTime3s') this.wednesdayStart,
      @JsonKey(name: 'dutyTime3c') this.wednesdayEnd,
      @JsonKey(name: 'dutyTime4s') this.thursdayStart,
      @JsonKey(name: 'dutyTime4c') this.thursdayEnd,
      @JsonKey(name: 'dutyTime5s') this.fridayStart,
      @JsonKey(name: 'dutyTime5c') this.fridayEnd,
      @JsonKey(name: 'dutyTime6s') this.saturdayStart,
      @JsonKey(name: 'dutyTime6c') this.saturdayEnd,
      @JsonKey(name: 'dutyTime7s') this.sundayStart,
      @JsonKey(name: 'dutyTime7c') this.sundayEnd,
      @JsonKey(name: 'dutyTime8s') this.holidayStart,
      @JsonKey(name: 'dutyTime8c') this.holidayEnd})
      : super._();

  factory _$EmergencyRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyRoomImplFromJson(json);

  @override
  @JsonKey(name: 'hpid')
  final String hpid;
// 기관ID
  @override
  @JsonKey(name: 'dutyName')
  final String dutyName;
// 기관명
  @override
  @JsonKey(name: 'dutyAddr')
  final String? dutyAddr;
// 주소 (가용병상정보 조회시 없을 수 있음)
  @override
  @JsonKey(name: 'dutyTel1')
  final String? dutyTel1;
// 대표전화
  @override
  @JsonKey(name: 'dutyTel3')
  final String? dutyTel3;
// 응급실전화
  @override
  @JsonKey(name: 'wgs84Lon')
  final String? longitude;
// 병원경도
  @override
  @JsonKey(name: 'wgs84Lat')
  final String? latitude;
// 병원위도
  @override
  @JsonKey(name: 'dutyEmcls')
  final String? dutyEmcls;
// 응급의료기관분류
  @override
  @JsonKey(name: 'dutyEmclsName')
  final String? dutyEmclsName;
// 응급의료기관분류명
  @override
  @JsonKey(name: 'distance')
  final double? distance;
// 거리 (위치기반 검색 시)
// 가용병상정보
  @override
  @JsonKey(name: 'hvec')
  final int? availableGeneralBeds;
// 응급실 일반병상
  @override
  @JsonKey(name: 'hvoc')
  final int? availableOperatingRooms;
// 수술실
  @override
  @JsonKey(name: 'hvcc')
  final int? availableNeuroICU;
// 신경중환자실
  @override
  @JsonKey(name: 'hvncc')
  final int? availableNeonatalICU;
// 신생아중환자실
  @override
  @JsonKey(name: 'hvccc')
  final int? availableChestICU;
// 흉부중환자실
  @override
  @JsonKey(name: 'hvicc')
  final int? availableGeneralICU;
// 일반중환자실
  @override
  @JsonKey(name: 'hvgc')
  final int? availableAdmissionRooms;
// 입원실
// 가용여부
  @override
  @JsonKey(name: 'hvctayn')
  final String? ctAvailable;
// CT가용여부 (Y/N)
  @override
  @JsonKey(name: 'hvmriayn')
  final String? mriAvailable;
// MRI가용여부 (Y/N)
  @override
  @JsonKey(name: 'hvamyn')
  final String? ambulanceAvailable;
// 구급차가용여부 (Y/N)
// 진료시간
  @override
  @JsonKey(name: 'dutyTime1s')
  final String? mondayStart;
  @override
  @JsonKey(name: 'dutyTime1c')
  final String? mondayEnd;
  @override
  @JsonKey(name: 'dutyTime2s')
  final String? tuesdayStart;
  @override
  @JsonKey(name: 'dutyTime2c')
  final String? tuesdayEnd;
  @override
  @JsonKey(name: 'dutyTime3s')
  final String? wednesdayStart;
  @override
  @JsonKey(name: 'dutyTime3c')
  final String? wednesdayEnd;
  @override
  @JsonKey(name: 'dutyTime4s')
  final String? thursdayStart;
  @override
  @JsonKey(name: 'dutyTime4c')
  final String? thursdayEnd;
  @override
  @JsonKey(name: 'dutyTime5s')
  final String? fridayStart;
  @override
  @JsonKey(name: 'dutyTime5c')
  final String? fridayEnd;
  @override
  @JsonKey(name: 'dutyTime6s')
  final String? saturdayStart;
  @override
  @JsonKey(name: 'dutyTime6c')
  final String? saturdayEnd;
  @override
  @JsonKey(name: 'dutyTime7s')
  final String? sundayStart;
  @override
  @JsonKey(name: 'dutyTime7c')
  final String? sundayEnd;
  @override
  @JsonKey(name: 'dutyTime8s')
  final String? holidayStart;
  @override
  @JsonKey(name: 'dutyTime8c')
  final String? holidayEnd;

  @override
  String toString() {
    return 'EmergencyRoom(hpid: $hpid, dutyName: $dutyName, dutyAddr: $dutyAddr, dutyTel1: $dutyTel1, dutyTel3: $dutyTel3, longitude: $longitude, latitude: $latitude, dutyEmcls: $dutyEmcls, dutyEmclsName: $dutyEmclsName, distance: $distance, availableGeneralBeds: $availableGeneralBeds, availableOperatingRooms: $availableOperatingRooms, availableNeuroICU: $availableNeuroICU, availableNeonatalICU: $availableNeonatalICU, availableChestICU: $availableChestICU, availableGeneralICU: $availableGeneralICU, availableAdmissionRooms: $availableAdmissionRooms, ctAvailable: $ctAvailable, mriAvailable: $mriAvailable, ambulanceAvailable: $ambulanceAvailable, mondayStart: $mondayStart, mondayEnd: $mondayEnd, tuesdayStart: $tuesdayStart, tuesdayEnd: $tuesdayEnd, wednesdayStart: $wednesdayStart, wednesdayEnd: $wednesdayEnd, thursdayStart: $thursdayStart, thursdayEnd: $thursdayEnd, fridayStart: $fridayStart, fridayEnd: $fridayEnd, saturdayStart: $saturdayStart, saturdayEnd: $saturdayEnd, sundayStart: $sundayStart, sundayEnd: $sundayEnd, holidayStart: $holidayStart, holidayEnd: $holidayEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyRoomImpl &&
            (identical(other.hpid, hpid) || other.hpid == hpid) &&
            (identical(other.dutyName, dutyName) ||
                other.dutyName == dutyName) &&
            (identical(other.dutyAddr, dutyAddr) ||
                other.dutyAddr == dutyAddr) &&
            (identical(other.dutyTel1, dutyTel1) ||
                other.dutyTel1 == dutyTel1) &&
            (identical(other.dutyTel3, dutyTel3) ||
                other.dutyTel3 == dutyTel3) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.dutyEmcls, dutyEmcls) ||
                other.dutyEmcls == dutyEmcls) &&
            (identical(other.dutyEmclsName, dutyEmclsName) ||
                other.dutyEmclsName == dutyEmclsName) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.availableGeneralBeds, availableGeneralBeds) ||
                other.availableGeneralBeds == availableGeneralBeds) &&
            (identical(other.availableOperatingRooms, availableOperatingRooms) ||
                other.availableOperatingRooms == availableOperatingRooms) &&
            (identical(other.availableNeuroICU, availableNeuroICU) ||
                other.availableNeuroICU == availableNeuroICU) &&
            (identical(other.availableNeonatalICU, availableNeonatalICU) ||
                other.availableNeonatalICU == availableNeonatalICU) &&
            (identical(other.availableChestICU, availableChestICU) ||
                other.availableChestICU == availableChestICU) &&
            (identical(other.availableGeneralICU, availableGeneralICU) ||
                other.availableGeneralICU == availableGeneralICU) &&
            (identical(other.availableAdmissionRooms, availableAdmissionRooms) ||
                other.availableAdmissionRooms == availableAdmissionRooms) &&
            (identical(other.ctAvailable, ctAvailable) ||
                other.ctAvailable == ctAvailable) &&
            (identical(other.mriAvailable, mriAvailable) ||
                other.mriAvailable == mriAvailable) &&
            (identical(other.ambulanceAvailable, ambulanceAvailable) ||
                other.ambulanceAvailable == ambulanceAvailable) &&
            (identical(other.mondayStart, mondayStart) ||
                other.mondayStart == mondayStart) &&
            (identical(other.mondayEnd, mondayEnd) ||
                other.mondayEnd == mondayEnd) &&
            (identical(other.tuesdayStart, tuesdayStart) ||
                other.tuesdayStart == tuesdayStart) &&
            (identical(other.tuesdayEnd, tuesdayEnd) ||
                other.tuesdayEnd == tuesdayEnd) &&
            (identical(other.wednesdayStart, wednesdayStart) ||
                other.wednesdayStart == wednesdayStart) &&
            (identical(other.wednesdayEnd, wednesdayEnd) ||
                other.wednesdayEnd == wednesdayEnd) &&
            (identical(other.thursdayStart, thursdayStart) ||
                other.thursdayStart == thursdayStart) &&
            (identical(other.thursdayEnd, thursdayEnd) ||
                other.thursdayEnd == thursdayEnd) &&
            (identical(other.fridayStart, fridayStart) ||
                other.fridayStart == fridayStart) &&
            (identical(other.fridayEnd, fridayEnd) ||
                other.fridayEnd == fridayEnd) &&
            (identical(other.saturdayStart, saturdayStart) ||
                other.saturdayStart == saturdayStart) &&
            (identical(other.saturdayEnd, saturdayEnd) ||
                other.saturdayEnd == saturdayEnd) &&
            (identical(other.sundayStart, sundayStart) ||
                other.sundayStart == sundayStart) &&
            (identical(other.sundayEnd, sundayEnd) ||
                other.sundayEnd == sundayEnd) &&
            (identical(other.holidayStart, holidayStart) || other.holidayStart == holidayStart) &&
            (identical(other.holidayEnd, holidayEnd) || other.holidayEnd == holidayEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        hpid,
        dutyName,
        dutyAddr,
        dutyTel1,
        dutyTel3,
        longitude,
        latitude,
        dutyEmcls,
        dutyEmclsName,
        distance,
        availableGeneralBeds,
        availableOperatingRooms,
        availableNeuroICU,
        availableNeonatalICU,
        availableChestICU,
        availableGeneralICU,
        availableAdmissionRooms,
        ctAvailable,
        mriAvailable,
        ambulanceAvailable,
        mondayStart,
        mondayEnd,
        tuesdayStart,
        tuesdayEnd,
        wednesdayStart,
        wednesdayEnd,
        thursdayStart,
        thursdayEnd,
        fridayStart,
        fridayEnd,
        saturdayStart,
        saturdayEnd,
        sundayStart,
        sundayEnd,
        holidayStart,
        holidayEnd
      ]);

  /// Create a copy of EmergencyRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyRoomImplCopyWith<_$EmergencyRoomImpl> get copyWith =>
      __$$EmergencyRoomImplCopyWithImpl<_$EmergencyRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyRoomImplToJson(
      this,
    );
  }
}

abstract class _EmergencyRoom extends EmergencyRoom {
  const factory _EmergencyRoom(
          {@JsonKey(name: 'hpid') required final String hpid,
          @JsonKey(name: 'dutyName') required final String dutyName,
          @JsonKey(name: 'dutyAddr') final String? dutyAddr,
          @JsonKey(name: 'dutyTel1') final String? dutyTel1,
          @JsonKey(name: 'dutyTel3') final String? dutyTel3,
          @JsonKey(name: 'wgs84Lon') final String? longitude,
          @JsonKey(name: 'wgs84Lat') final String? latitude,
          @JsonKey(name: 'dutyEmcls') final String? dutyEmcls,
          @JsonKey(name: 'dutyEmclsName') final String? dutyEmclsName,
          @JsonKey(name: 'distance') final double? distance,
          @JsonKey(name: 'hvec') final int? availableGeneralBeds,
          @JsonKey(name: 'hvoc') final int? availableOperatingRooms,
          @JsonKey(name: 'hvcc') final int? availableNeuroICU,
          @JsonKey(name: 'hvncc') final int? availableNeonatalICU,
          @JsonKey(name: 'hvccc') final int? availableChestICU,
          @JsonKey(name: 'hvicc') final int? availableGeneralICU,
          @JsonKey(name: 'hvgc') final int? availableAdmissionRooms,
          @JsonKey(name: 'hvctayn') final String? ctAvailable,
          @JsonKey(name: 'hvmriayn') final String? mriAvailable,
          @JsonKey(name: 'hvamyn') final String? ambulanceAvailable,
          @JsonKey(name: 'dutyTime1s') final String? mondayStart,
          @JsonKey(name: 'dutyTime1c') final String? mondayEnd,
          @JsonKey(name: 'dutyTime2s') final String? tuesdayStart,
          @JsonKey(name: 'dutyTime2c') final String? tuesdayEnd,
          @JsonKey(name: 'dutyTime3s') final String? wednesdayStart,
          @JsonKey(name: 'dutyTime3c') final String? wednesdayEnd,
          @JsonKey(name: 'dutyTime4s') final String? thursdayStart,
          @JsonKey(name: 'dutyTime4c') final String? thursdayEnd,
          @JsonKey(name: 'dutyTime5s') final String? fridayStart,
          @JsonKey(name: 'dutyTime5c') final String? fridayEnd,
          @JsonKey(name: 'dutyTime6s') final String? saturdayStart,
          @JsonKey(name: 'dutyTime6c') final String? saturdayEnd,
          @JsonKey(name: 'dutyTime7s') final String? sundayStart,
          @JsonKey(name: 'dutyTime7c') final String? sundayEnd,
          @JsonKey(name: 'dutyTime8s') final String? holidayStart,
          @JsonKey(name: 'dutyTime8c') final String? holidayEnd}) =
      _$EmergencyRoomImpl;
  const _EmergencyRoom._() : super._();

  factory _EmergencyRoom.fromJson(Map<String, dynamic> json) =
      _$EmergencyRoomImpl.fromJson;

  @override
  @JsonKey(name: 'hpid')
  String get hpid; // 기관ID
  @override
  @JsonKey(name: 'dutyName')
  String get dutyName; // 기관명
  @override
  @JsonKey(name: 'dutyAddr')
  String? get dutyAddr; // 주소 (가용병상정보 조회시 없을 수 있음)
  @override
  @JsonKey(name: 'dutyTel1')
  String? get dutyTel1; // 대표전화
  @override
  @JsonKey(name: 'dutyTel3')
  String? get dutyTel3; // 응급실전화
  @override
  @JsonKey(name: 'wgs84Lon')
  String? get longitude; // 병원경도
  @override
  @JsonKey(name: 'wgs84Lat')
  String? get latitude; // 병원위도
  @override
  @JsonKey(name: 'dutyEmcls')
  String? get dutyEmcls; // 응급의료기관분류
  @override
  @JsonKey(name: 'dutyEmclsName')
  String? get dutyEmclsName; // 응급의료기관분류명
  @override
  @JsonKey(name: 'distance')
  double? get distance; // 거리 (위치기반 검색 시)
// 가용병상정보
  @override
  @JsonKey(name: 'hvec')
  int? get availableGeneralBeds; // 응급실 일반병상
  @override
  @JsonKey(name: 'hvoc')
  int? get availableOperatingRooms; // 수술실
  @override
  @JsonKey(name: 'hvcc')
  int? get availableNeuroICU; // 신경중환자실
  @override
  @JsonKey(name: 'hvncc')
  int? get availableNeonatalICU; // 신생아중환자실
  @override
  @JsonKey(name: 'hvccc')
  int? get availableChestICU; // 흉부중환자실
  @override
  @JsonKey(name: 'hvicc')
  int? get availableGeneralICU; // 일반중환자실
  @override
  @JsonKey(name: 'hvgc')
  int? get availableAdmissionRooms; // 입원실
// 가용여부
  @override
  @JsonKey(name: 'hvctayn')
  String? get ctAvailable; // CT가용여부 (Y/N)
  @override
  @JsonKey(name: 'hvmriayn')
  String? get mriAvailable; // MRI가용여부 (Y/N)
  @override
  @JsonKey(name: 'hvamyn')
  String? get ambulanceAvailable; // 구급차가용여부 (Y/N)
// 진료시간
  @override
  @JsonKey(name: 'dutyTime1s')
  String? get mondayStart;
  @override
  @JsonKey(name: 'dutyTime1c')
  String? get mondayEnd;
  @override
  @JsonKey(name: 'dutyTime2s')
  String? get tuesdayStart;
  @override
  @JsonKey(name: 'dutyTime2c')
  String? get tuesdayEnd;
  @override
  @JsonKey(name: 'dutyTime3s')
  String? get wednesdayStart;
  @override
  @JsonKey(name: 'dutyTime3c')
  String? get wednesdayEnd;
  @override
  @JsonKey(name: 'dutyTime4s')
  String? get thursdayStart;
  @override
  @JsonKey(name: 'dutyTime4c')
  String? get thursdayEnd;
  @override
  @JsonKey(name: 'dutyTime5s')
  String? get fridayStart;
  @override
  @JsonKey(name: 'dutyTime5c')
  String? get fridayEnd;
  @override
  @JsonKey(name: 'dutyTime6s')
  String? get saturdayStart;
  @override
  @JsonKey(name: 'dutyTime6c')
  String? get saturdayEnd;
  @override
  @JsonKey(name: 'dutyTime7s')
  String? get sundayStart;
  @override
  @JsonKey(name: 'dutyTime7c')
  String? get sundayEnd;
  @override
  @JsonKey(name: 'dutyTime8s')
  String? get holidayStart;
  @override
  @JsonKey(name: 'dutyTime8c')
  String? get holidayEnd;

  /// Create a copy of EmergencyRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergencyRoomImplCopyWith<_$EmergencyRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SeverePatientAcceptance _$SeverePatientAcceptanceFromJson(
    Map<String, dynamic> json) {
  return _SeverePatientAcceptance.fromJson(json);
}

/// @nodoc
mixin _$SeverePatientAcceptance {
  @JsonKey(name: 'hpid')
  String get hpid => throw _privateConstructorUsedError; // 기관ID
  @JsonKey(name: 'dutyName')
  String get dutyName => throw _privateConstructorUsedError; // 기관명
  @JsonKey(name: 'mkioskty28')
  String? get emergencyGateKeeper =>
      throw _privateConstructorUsedError; // 응급실(Emergency gate keeper)
  @JsonKey(name: 'mkioskty1')
  String? get myocardialInfarction =>
      throw _privateConstructorUsedError; // [재관류중재술] 심근경색
  @JsonKey(name: 'mkioskty2')
  String? get cerebralInfarction =>
      throw _privateConstructorUsedError; // [재관류중재술] 뇌경색
  @JsonKey(name: 'mkioskty3')
  String? get subarachnoidHemorrhage =>
      throw _privateConstructorUsedError; // [뇌출혈수술] 거미막하출혈
  @JsonKey(name: 'mkioskty4')
  String? get otherCerebralHemorrhage => throw _privateConstructorUsedError;

  /// Serializes this SeverePatientAcceptance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeverePatientAcceptance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeverePatientAcceptanceCopyWith<SeverePatientAcceptance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeverePatientAcceptanceCopyWith<$Res> {
  factory $SeverePatientAcceptanceCopyWith(SeverePatientAcceptance value,
          $Res Function(SeverePatientAcceptance) then) =
      _$SeverePatientAcceptanceCopyWithImpl<$Res, SeverePatientAcceptance>;
  @useResult
  $Res call(
      {@JsonKey(name: 'hpid') String hpid,
      @JsonKey(name: 'dutyName') String dutyName,
      @JsonKey(name: 'mkioskty28') String? emergencyGateKeeper,
      @JsonKey(name: 'mkioskty1') String? myocardialInfarction,
      @JsonKey(name: 'mkioskty2') String? cerebralInfarction,
      @JsonKey(name: 'mkioskty3') String? subarachnoidHemorrhage,
      @JsonKey(name: 'mkioskty4') String? otherCerebralHemorrhage});
}

/// @nodoc
class _$SeverePatientAcceptanceCopyWithImpl<$Res,
        $Val extends SeverePatientAcceptance>
    implements $SeverePatientAcceptanceCopyWith<$Res> {
  _$SeverePatientAcceptanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeverePatientAcceptance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hpid = null,
    Object? dutyName = null,
    Object? emergencyGateKeeper = freezed,
    Object? myocardialInfarction = freezed,
    Object? cerebralInfarction = freezed,
    Object? subarachnoidHemorrhage = freezed,
    Object? otherCerebralHemorrhage = freezed,
  }) {
    return _then(_value.copyWith(
      hpid: null == hpid
          ? _value.hpid
          : hpid // ignore: cast_nullable_to_non_nullable
              as String,
      dutyName: null == dutyName
          ? _value.dutyName
          : dutyName // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyGateKeeper: freezed == emergencyGateKeeper
          ? _value.emergencyGateKeeper
          : emergencyGateKeeper // ignore: cast_nullable_to_non_nullable
              as String?,
      myocardialInfarction: freezed == myocardialInfarction
          ? _value.myocardialInfarction
          : myocardialInfarction // ignore: cast_nullable_to_non_nullable
              as String?,
      cerebralInfarction: freezed == cerebralInfarction
          ? _value.cerebralInfarction
          : cerebralInfarction // ignore: cast_nullable_to_non_nullable
              as String?,
      subarachnoidHemorrhage: freezed == subarachnoidHemorrhage
          ? _value.subarachnoidHemorrhage
          : subarachnoidHemorrhage // ignore: cast_nullable_to_non_nullable
              as String?,
      otherCerebralHemorrhage: freezed == otherCerebralHemorrhage
          ? _value.otherCerebralHemorrhage
          : otherCerebralHemorrhage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SeverePatientAcceptanceImplCopyWith<$Res>
    implements $SeverePatientAcceptanceCopyWith<$Res> {
  factory _$$SeverePatientAcceptanceImplCopyWith(
          _$SeverePatientAcceptanceImpl value,
          $Res Function(_$SeverePatientAcceptanceImpl) then) =
      __$$SeverePatientAcceptanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'hpid') String hpid,
      @JsonKey(name: 'dutyName') String dutyName,
      @JsonKey(name: 'mkioskty28') String? emergencyGateKeeper,
      @JsonKey(name: 'mkioskty1') String? myocardialInfarction,
      @JsonKey(name: 'mkioskty2') String? cerebralInfarction,
      @JsonKey(name: 'mkioskty3') String? subarachnoidHemorrhage,
      @JsonKey(name: 'mkioskty4') String? otherCerebralHemorrhage});
}

/// @nodoc
class __$$SeverePatientAcceptanceImplCopyWithImpl<$Res>
    extends _$SeverePatientAcceptanceCopyWithImpl<$Res,
        _$SeverePatientAcceptanceImpl>
    implements _$$SeverePatientAcceptanceImplCopyWith<$Res> {
  __$$SeverePatientAcceptanceImplCopyWithImpl(
      _$SeverePatientAcceptanceImpl _value,
      $Res Function(_$SeverePatientAcceptanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of SeverePatientAcceptance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hpid = null,
    Object? dutyName = null,
    Object? emergencyGateKeeper = freezed,
    Object? myocardialInfarction = freezed,
    Object? cerebralInfarction = freezed,
    Object? subarachnoidHemorrhage = freezed,
    Object? otherCerebralHemorrhage = freezed,
  }) {
    return _then(_$SeverePatientAcceptanceImpl(
      hpid: null == hpid
          ? _value.hpid
          : hpid // ignore: cast_nullable_to_non_nullable
              as String,
      dutyName: null == dutyName
          ? _value.dutyName
          : dutyName // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyGateKeeper: freezed == emergencyGateKeeper
          ? _value.emergencyGateKeeper
          : emergencyGateKeeper // ignore: cast_nullable_to_non_nullable
              as String?,
      myocardialInfarction: freezed == myocardialInfarction
          ? _value.myocardialInfarction
          : myocardialInfarction // ignore: cast_nullable_to_non_nullable
              as String?,
      cerebralInfarction: freezed == cerebralInfarction
          ? _value.cerebralInfarction
          : cerebralInfarction // ignore: cast_nullable_to_non_nullable
              as String?,
      subarachnoidHemorrhage: freezed == subarachnoidHemorrhage
          ? _value.subarachnoidHemorrhage
          : subarachnoidHemorrhage // ignore: cast_nullable_to_non_nullable
              as String?,
      otherCerebralHemorrhage: freezed == otherCerebralHemorrhage
          ? _value.otherCerebralHemorrhage
          : otherCerebralHemorrhage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SeverePatientAcceptanceImpl implements _SeverePatientAcceptance {
  const _$SeverePatientAcceptanceImpl(
      {@JsonKey(name: 'hpid') required this.hpid,
      @JsonKey(name: 'dutyName') required this.dutyName,
      @JsonKey(name: 'mkioskty28') this.emergencyGateKeeper,
      @JsonKey(name: 'mkioskty1') this.myocardialInfarction,
      @JsonKey(name: 'mkioskty2') this.cerebralInfarction,
      @JsonKey(name: 'mkioskty3') this.subarachnoidHemorrhage,
      @JsonKey(name: 'mkioskty4') this.otherCerebralHemorrhage});

  factory _$SeverePatientAcceptanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeverePatientAcceptanceImplFromJson(json);

  @override
  @JsonKey(name: 'hpid')
  final String hpid;
// 기관ID
  @override
  @JsonKey(name: 'dutyName')
  final String dutyName;
// 기관명
  @override
  @JsonKey(name: 'mkioskty28')
  final String? emergencyGateKeeper;
// 응급실(Emergency gate keeper)
  @override
  @JsonKey(name: 'mkioskty1')
  final String? myocardialInfarction;
// [재관류중재술] 심근경색
  @override
  @JsonKey(name: 'mkioskty2')
  final String? cerebralInfarction;
// [재관류중재술] 뇌경색
  @override
  @JsonKey(name: 'mkioskty3')
  final String? subarachnoidHemorrhage;
// [뇌출혈수술] 거미막하출혈
  @override
  @JsonKey(name: 'mkioskty4')
  final String? otherCerebralHemorrhage;

  @override
  String toString() {
    return 'SeverePatientAcceptance(hpid: $hpid, dutyName: $dutyName, emergencyGateKeeper: $emergencyGateKeeper, myocardialInfarction: $myocardialInfarction, cerebralInfarction: $cerebralInfarction, subarachnoidHemorrhage: $subarachnoidHemorrhage, otherCerebralHemorrhage: $otherCerebralHemorrhage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeverePatientAcceptanceImpl &&
            (identical(other.hpid, hpid) || other.hpid == hpid) &&
            (identical(other.dutyName, dutyName) ||
                other.dutyName == dutyName) &&
            (identical(other.emergencyGateKeeper, emergencyGateKeeper) ||
                other.emergencyGateKeeper == emergencyGateKeeper) &&
            (identical(other.myocardialInfarction, myocardialInfarction) ||
                other.myocardialInfarction == myocardialInfarction) &&
            (identical(other.cerebralInfarction, cerebralInfarction) ||
                other.cerebralInfarction == cerebralInfarction) &&
            (identical(other.subarachnoidHemorrhage, subarachnoidHemorrhage) ||
                other.subarachnoidHemorrhage == subarachnoidHemorrhage) &&
            (identical(
                    other.otherCerebralHemorrhage, otherCerebralHemorrhage) ||
                other.otherCerebralHemorrhage == otherCerebralHemorrhage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hpid,
      dutyName,
      emergencyGateKeeper,
      myocardialInfarction,
      cerebralInfarction,
      subarachnoidHemorrhage,
      otherCerebralHemorrhage);

  /// Create a copy of SeverePatientAcceptance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeverePatientAcceptanceImplCopyWith<_$SeverePatientAcceptanceImpl>
      get copyWith => __$$SeverePatientAcceptanceImplCopyWithImpl<
          _$SeverePatientAcceptanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeverePatientAcceptanceImplToJson(
      this,
    );
  }
}

abstract class _SeverePatientAcceptance implements SeverePatientAcceptance {
  const factory _SeverePatientAcceptance(
          {@JsonKey(name: 'hpid') required final String hpid,
          @JsonKey(name: 'dutyName') required final String dutyName,
          @JsonKey(name: 'mkioskty28') final String? emergencyGateKeeper,
          @JsonKey(name: 'mkioskty1') final String? myocardialInfarction,
          @JsonKey(name: 'mkioskty2') final String? cerebralInfarction,
          @JsonKey(name: 'mkioskty3') final String? subarachnoidHemorrhage,
          @JsonKey(name: 'mkioskty4') final String? otherCerebralHemorrhage}) =
      _$SeverePatientAcceptanceImpl;

  factory _SeverePatientAcceptance.fromJson(Map<String, dynamic> json) =
      _$SeverePatientAcceptanceImpl.fromJson;

  @override
  @JsonKey(name: 'hpid')
  String get hpid; // 기관ID
  @override
  @JsonKey(name: 'dutyName')
  String get dutyName; // 기관명
  @override
  @JsonKey(name: 'mkioskty28')
  String? get emergencyGateKeeper; // 응급실(Emergency gate keeper)
  @override
  @JsonKey(name: 'mkioskty1')
  String? get myocardialInfarction; // [재관류중재술] 심근경색
  @override
  @JsonKey(name: 'mkioskty2')
  String? get cerebralInfarction; // [재관류중재술] 뇌경색
  @override
  @JsonKey(name: 'mkioskty3')
  String? get subarachnoidHemorrhage; // [뇌출혈수술] 거미막하출혈
  @override
  @JsonKey(name: 'mkioskty4')
  String? get otherCerebralHemorrhage;

  /// Create a copy of SeverePatientAcceptance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeverePatientAcceptanceImplCopyWith<_$SeverePatientAcceptanceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EmergencyMessage _$EmergencyMessageFromJson(Map<String, dynamic> json) {
  return _EmergencyMessage.fromJson(json);
}

/// @nodoc
mixin _$EmergencyMessage {
  @JsonKey(name: 'hpid')
  String get hpid => throw _privateConstructorUsedError; // 기관ID
  @JsonKey(name: 'symBlkMsg')
  String? get message => throw _privateConstructorUsedError; // 메시지 내용
  @JsonKey(name: 'symBlkMsgTyp')
  String? get messageType => throw _privateConstructorUsedError; // 메시지 유형
  @JsonKey(name: 'symTypCod')
  String? get symptomTypeCode => throw _privateConstructorUsedError; // 증상 유형 코드
  @JsonKey(name: 'symTypCodMag')
  String? get symptomTypeName => throw _privateConstructorUsedError;

  /// Serializes this EmergencyMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmergencyMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergencyMessageCopyWith<EmergencyMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyMessageCopyWith<$Res> {
  factory $EmergencyMessageCopyWith(
          EmergencyMessage value, $Res Function(EmergencyMessage) then) =
      _$EmergencyMessageCopyWithImpl<$Res, EmergencyMessage>;
  @useResult
  $Res call(
      {@JsonKey(name: 'hpid') String hpid,
      @JsonKey(name: 'symBlkMsg') String? message,
      @JsonKey(name: 'symBlkMsgTyp') String? messageType,
      @JsonKey(name: 'symTypCod') String? symptomTypeCode,
      @JsonKey(name: 'symTypCodMag') String? symptomTypeName});
}

/// @nodoc
class _$EmergencyMessageCopyWithImpl<$Res, $Val extends EmergencyMessage>
    implements $EmergencyMessageCopyWith<$Res> {
  _$EmergencyMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergencyMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hpid = null,
    Object? message = freezed,
    Object? messageType = freezed,
    Object? symptomTypeCode = freezed,
    Object? symptomTypeName = freezed,
  }) {
    return _then(_value.copyWith(
      hpid: null == hpid
          ? _value.hpid
          : hpid // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      messageType: freezed == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String?,
      symptomTypeCode: freezed == symptomTypeCode
          ? _value.symptomTypeCode
          : symptomTypeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      symptomTypeName: freezed == symptomTypeName
          ? _value.symptomTypeName
          : symptomTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmergencyMessageImplCopyWith<$Res>
    implements $EmergencyMessageCopyWith<$Res> {
  factory _$$EmergencyMessageImplCopyWith(_$EmergencyMessageImpl value,
          $Res Function(_$EmergencyMessageImpl) then) =
      __$$EmergencyMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'hpid') String hpid,
      @JsonKey(name: 'symBlkMsg') String? message,
      @JsonKey(name: 'symBlkMsgTyp') String? messageType,
      @JsonKey(name: 'symTypCod') String? symptomTypeCode,
      @JsonKey(name: 'symTypCodMag') String? symptomTypeName});
}

/// @nodoc
class __$$EmergencyMessageImplCopyWithImpl<$Res>
    extends _$EmergencyMessageCopyWithImpl<$Res, _$EmergencyMessageImpl>
    implements _$$EmergencyMessageImplCopyWith<$Res> {
  __$$EmergencyMessageImplCopyWithImpl(_$EmergencyMessageImpl _value,
      $Res Function(_$EmergencyMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmergencyMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hpid = null,
    Object? message = freezed,
    Object? messageType = freezed,
    Object? symptomTypeCode = freezed,
    Object? symptomTypeName = freezed,
  }) {
    return _then(_$EmergencyMessageImpl(
      hpid: null == hpid
          ? _value.hpid
          : hpid // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      messageType: freezed == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String?,
      symptomTypeCode: freezed == symptomTypeCode
          ? _value.symptomTypeCode
          : symptomTypeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      symptomTypeName: freezed == symptomTypeName
          ? _value.symptomTypeName
          : symptomTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyMessageImpl implements _EmergencyMessage {
  const _$EmergencyMessageImpl(
      {@JsonKey(name: 'hpid') required this.hpid,
      @JsonKey(name: 'symBlkMsg') this.message,
      @JsonKey(name: 'symBlkMsgTyp') this.messageType,
      @JsonKey(name: 'symTypCod') this.symptomTypeCode,
      @JsonKey(name: 'symTypCodMag') this.symptomTypeName});

  factory _$EmergencyMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyMessageImplFromJson(json);

  @override
  @JsonKey(name: 'hpid')
  final String hpid;
// 기관ID
  @override
  @JsonKey(name: 'symBlkMsg')
  final String? message;
// 메시지 내용
  @override
  @JsonKey(name: 'symBlkMsgTyp')
  final String? messageType;
// 메시지 유형
  @override
  @JsonKey(name: 'symTypCod')
  final String? symptomTypeCode;
// 증상 유형 코드
  @override
  @JsonKey(name: 'symTypCodMag')
  final String? symptomTypeName;

  @override
  String toString() {
    return 'EmergencyMessage(hpid: $hpid, message: $message, messageType: $messageType, symptomTypeCode: $symptomTypeCode, symptomTypeName: $symptomTypeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyMessageImpl &&
            (identical(other.hpid, hpid) || other.hpid == hpid) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.symptomTypeCode, symptomTypeCode) ||
                other.symptomTypeCode == symptomTypeCode) &&
            (identical(other.symptomTypeName, symptomTypeName) ||
                other.symptomTypeName == symptomTypeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hpid, message, messageType,
      symptomTypeCode, symptomTypeName);

  /// Create a copy of EmergencyMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyMessageImplCopyWith<_$EmergencyMessageImpl> get copyWith =>
      __$$EmergencyMessageImplCopyWithImpl<_$EmergencyMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyMessageImplToJson(
      this,
    );
  }
}

abstract class _EmergencyMessage implements EmergencyMessage {
  const factory _EmergencyMessage(
          {@JsonKey(name: 'hpid') required final String hpid,
          @JsonKey(name: 'symBlkMsg') final String? message,
          @JsonKey(name: 'symBlkMsgTyp') final String? messageType,
          @JsonKey(name: 'symTypCod') final String? symptomTypeCode,
          @JsonKey(name: 'symTypCodMag') final String? symptomTypeName}) =
      _$EmergencyMessageImpl;

  factory _EmergencyMessage.fromJson(Map<String, dynamic> json) =
      _$EmergencyMessageImpl.fromJson;

  @override
  @JsonKey(name: 'hpid')
  String get hpid; // 기관ID
  @override
  @JsonKey(name: 'symBlkMsg')
  String? get message; // 메시지 내용
  @override
  @JsonKey(name: 'symBlkMsgTyp')
  String? get messageType; // 메시지 유형
  @override
  @JsonKey(name: 'symTypCod')
  String? get symptomTypeCode; // 증상 유형 코드
  @override
  @JsonKey(name: 'symTypCodMag')
  String? get symptomTypeName;

  /// Create a copy of EmergencyMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergencyMessageImplCopyWith<_$EmergencyMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
