// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmergencyRoomImpl _$$EmergencyRoomImplFromJson(Map<String, dynamic> json) =>
    _$EmergencyRoomImpl(
      hpid: json['hpid'] as String,
      dutyName: json['dutyName'] as String,
      dutyAddr: json['dutyAddr'] as String?,
      dutyTel1: json['dutyTel1'] as String?,
      dutyTel3: json['dutyTel3'] as String?,
      longitude: json['wgs84Lon'] as String?,
      latitude: json['wgs84Lat'] as String?,
      dutyEmcls: json['dutyEmcls'] as String?,
      dutyEmclsName: json['dutyEmclsName'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      availableGeneralBeds: (json['hvec'] as num?)?.toInt(),
      availableOperatingRooms: (json['hvoc'] as num?)?.toInt(),
      availableNeuroICU: (json['hvcc'] as num?)?.toInt(),
      availableNeonatalICU: (json['hvncc'] as num?)?.toInt(),
      availableChestICU: (json['hvccc'] as num?)?.toInt(),
      availableGeneralICU: (json['hvicc'] as num?)?.toInt(),
      availableAdmissionRooms: (json['hvgc'] as num?)?.toInt(),
      ctAvailable: json['hvctayn'] as String?,
      mriAvailable: json['hvmriayn'] as String?,
      ambulanceAvailable: json['hvamyn'] as String?,
      mondayStart: json['dutyTime1s'] as String?,
      mondayEnd: json['dutyTime1c'] as String?,
      tuesdayStart: json['dutyTime2s'] as String?,
      tuesdayEnd: json['dutyTime2c'] as String?,
      wednesdayStart: json['dutyTime3s'] as String?,
      wednesdayEnd: json['dutyTime3c'] as String?,
      thursdayStart: json['dutyTime4s'] as String?,
      thursdayEnd: json['dutyTime4c'] as String?,
      fridayStart: json['dutyTime5s'] as String?,
      fridayEnd: json['dutyTime5c'] as String?,
      saturdayStart: json['dutyTime6s'] as String?,
      saturdayEnd: json['dutyTime6c'] as String?,
      sundayStart: json['dutyTime7s'] as String?,
      sundayEnd: json['dutyTime7c'] as String?,
      holidayStart: json['dutyTime8s'] as String?,
      holidayEnd: json['dutyTime8c'] as String?,
    );

Map<String, dynamic> _$$EmergencyRoomImplToJson(_$EmergencyRoomImpl instance) =>
    <String, dynamic>{
      'hpid': instance.hpid,
      'dutyName': instance.dutyName,
      'dutyAddr': instance.dutyAddr,
      'dutyTel1': instance.dutyTel1,
      'dutyTel3': instance.dutyTel3,
      'wgs84Lon': instance.longitude,
      'wgs84Lat': instance.latitude,
      'dutyEmcls': instance.dutyEmcls,
      'dutyEmclsName': instance.dutyEmclsName,
      'distance': instance.distance,
      'hvec': instance.availableGeneralBeds,
      'hvoc': instance.availableOperatingRooms,
      'hvcc': instance.availableNeuroICU,
      'hvncc': instance.availableNeonatalICU,
      'hvccc': instance.availableChestICU,
      'hvicc': instance.availableGeneralICU,
      'hvgc': instance.availableAdmissionRooms,
      'hvctayn': instance.ctAvailable,
      'hvmriayn': instance.mriAvailable,
      'hvamyn': instance.ambulanceAvailable,
      'dutyTime1s': instance.mondayStart,
      'dutyTime1c': instance.mondayEnd,
      'dutyTime2s': instance.tuesdayStart,
      'dutyTime2c': instance.tuesdayEnd,
      'dutyTime3s': instance.wednesdayStart,
      'dutyTime3c': instance.wednesdayEnd,
      'dutyTime4s': instance.thursdayStart,
      'dutyTime4c': instance.thursdayEnd,
      'dutyTime5s': instance.fridayStart,
      'dutyTime5c': instance.fridayEnd,
      'dutyTime6s': instance.saturdayStart,
      'dutyTime6c': instance.saturdayEnd,
      'dutyTime7s': instance.sundayStart,
      'dutyTime7c': instance.sundayEnd,
      'dutyTime8s': instance.holidayStart,
      'dutyTime8c': instance.holidayEnd,
    };

_$SeverePatientAcceptanceImpl _$$SeverePatientAcceptanceImplFromJson(
        Map<String, dynamic> json) =>
    _$SeverePatientAcceptanceImpl(
      hpid: json['hpid'] as String,
      dutyName: json['dutyName'] as String,
      emergencyGateKeeper: json['mkioskty28'] as String?,
      myocardialInfarction: json['mkioskty1'] as String?,
      cerebralInfarction: json['mkioskty2'] as String?,
      subarachnoidHemorrhage: json['mkioskty3'] as String?,
      otherCerebralHemorrhage: json['mkioskty4'] as String?,
    );

Map<String, dynamic> _$$SeverePatientAcceptanceImplToJson(
        _$SeverePatientAcceptanceImpl instance) =>
    <String, dynamic>{
      'hpid': instance.hpid,
      'dutyName': instance.dutyName,
      'mkioskty28': instance.emergencyGateKeeper,
      'mkioskty1': instance.myocardialInfarction,
      'mkioskty2': instance.cerebralInfarction,
      'mkioskty3': instance.subarachnoidHemorrhage,
      'mkioskty4': instance.otherCerebralHemorrhage,
    };

_$EmergencyMessageImpl _$$EmergencyMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$EmergencyMessageImpl(
      hpid: json['hpid'] as String,
      message: json['symBlkMsg'] as String?,
      messageType: json['symBlkMsgTyp'] as String?,
      symptomTypeCode: json['symTypCod'] as String?,
      symptomTypeName: json['symTypCodMag'] as String?,
    );

Map<String, dynamic> _$$EmergencyMessageImplToJson(
        _$EmergencyMessageImpl instance) =>
    <String, dynamic>{
      'hpid': instance.hpid,
      'symBlkMsg': instance.message,
      'symBlkMsgTyp': instance.messageType,
      'symTypCod': instance.symptomTypeCode,
      'symTypCodMag': instance.symptomTypeName,
    };
