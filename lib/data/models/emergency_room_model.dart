import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_room_model.freezed.dart';
part 'emergency_room_model.g.dart';

/// 응급실 정보 모델
@freezed
class EmergencyRoom with _$EmergencyRoom {
  const EmergencyRoom._();
  
  const factory EmergencyRoom({
    @JsonKey(name: 'hpid') required String hpid, // 기관ID
    @JsonKey(name: 'dutyName') required String dutyName, // 기관명
    @JsonKey(name: 'dutyAddr') String? dutyAddr, // 주소 (가용병상정보 조회시 없을 수 있음)
    @JsonKey(name: 'dutyTel1') String? dutyTel1, // 대표전화
    @JsonKey(name: 'dutyTel3') String? dutyTel3, // 응급실전화
    @JsonKey(name: 'wgs84Lon') String? longitude, // 병원경도
    @JsonKey(name: 'wgs84Lat') String? latitude, // 병원위도
    @JsonKey(name: 'dutyEmcls') String? dutyEmcls, // 응급의료기관분류
    @JsonKey(name: 'dutyEmclsName') String? dutyEmclsName, // 응급의료기관분류명
    @JsonKey(name: 'distance') double? distance, // 거리 (위치기반 검색 시)
    
    // 가용병상정보
    @JsonKey(name: 'hvec') int? availableGeneralBeds, // 응급실 일반병상
    @JsonKey(name: 'hvoc') int? availableOperatingRooms, // 수술실
    @JsonKey(name: 'hvcc') int? availableNeuroICU, // 신경중환자실
    @JsonKey(name: 'hvncc') int? availableNeonatalICU, // 신생아중환자실
    @JsonKey(name: 'hvccc') int? availableChestICU, // 흉부중환자실
    @JsonKey(name: 'hvicc') int? availableGeneralICU, // 일반중환자실
    @JsonKey(name: 'hvgc') int? availableAdmissionRooms, // 입원실
    
    // 가용여부
    @JsonKey(name: 'hvctayn') String? ctAvailable, // CT가용여부 (Y/N)
    @JsonKey(name: 'hvmriayn') String? mriAvailable, // MRI가용여부 (Y/N)
    @JsonKey(name: 'hvamyn') String? ambulanceAvailable, // 구급차가용여부 (Y/N)
    
    // 진료시간
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
    @JsonKey(name: 'dutyTime8c') String? holidayEnd,
  }) = _EmergencyRoom;

  factory EmergencyRoom.fromJson(Map<String, dynamic> json) =>
      _$EmergencyRoomFromJson(json);
}

/// 중증질환자 수용가능정보 모델
@freezed
class SeverePatientAcceptance with _$SeverePatientAcceptance {
  const factory SeverePatientAcceptance({
    @JsonKey(name: 'hpid') required String hpid, // 기관ID
    @JsonKey(name: 'dutyName') required String dutyName, // 기관명
    @JsonKey(name: 'mkioskty28') String? emergencyGateKeeper, // 응급실(Emergency gate keeper)
    @JsonKey(name: 'mkioskty1') String? myocardialInfarction, // [재관류중재술] 심근경색
    @JsonKey(name: 'mkioskty2') String? cerebralInfarction, // [재관류중재술] 뇌경색
    @JsonKey(name: 'mkioskty3') String? subarachnoidHemorrhage, // [뇌출혈수술] 거미막하출혈
    @JsonKey(name: 'mkioskty4') String? otherCerebralHemorrhage, // [뇌출혈수술] 거미막하출혈 외
  }) = _SeverePatientAcceptance;

  factory SeverePatientAcceptance.fromJson(Map<String, dynamic> json) =>
      _$SeverePatientAcceptanceFromJson(json);
}

/// 응급실 메시지 모델
@freezed
class EmergencyMessage with _$EmergencyMessage {
  const factory EmergencyMessage({
    @JsonKey(name: 'hpid') required String hpid, // 기관ID
    @JsonKey(name: 'symBlkMsg') String? message, // 메시지 내용
    @JsonKey(name: 'symBlkMsgTyp') String? messageType, // 메시지 유형
    @JsonKey(name: 'symTypCod') String? symptomTypeCode, // 증상 유형 코드
    @JsonKey(name: 'symTypCodMag') String? symptomTypeName, // 증상 유형명
  }) = _EmergencyMessage;

  factory EmergencyMessage.fromJson(Map<String, dynamic> json) =>
      _$EmergencyMessageFromJson(json);
} 