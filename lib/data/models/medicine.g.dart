// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicineImpl _$$MedicineImplFromJson(Map<String, dynamic> json) =>
    _$MedicineImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      imageUrl: json['imageUrl'] as String?,
      efficacy: json['efficacy'] as String?,
      usage: json['usage'] as String?,
      precautions: json['precautions'] as String?,
      interactions: json['interactions'] as String?,
      sideEffects: json['sideEffects'] as String?,
      storage: json['storage'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      itemSeq: json['itemSeq'] as String?,
      itemPermitDate: json['itemPermitDate'] as String?,
      atpnWarnQesitm: json['atpnWarnQesitm'] as String?,
      atpnQesitm: json['atpnQesitm'] as String?,
      openDe: json['openDe'] as String?,
      updateDe: json['updateDe'] as String?,
      bizrno: json['bizrno'] as String?,
    );

Map<String, dynamic> _$$MedicineImplToJson(_$MedicineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'imageUrl': instance.imageUrl,
      'efficacy': instance.efficacy,
      'usage': instance.usage,
      'precautions': instance.precautions,
      'interactions': instance.interactions,
      'sideEffects': instance.sideEffects,
      'storage': instance.storage,
      'isFavorite': instance.isFavorite,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'itemSeq': instance.itemSeq,
      'itemPermitDate': instance.itemPermitDate,
      'atpnWarnQesitm': instance.atpnWarnQesitm,
      'atpnQesitm': instance.atpnQesitm,
      'openDe': instance.openDe,
      'updateDe': instance.updateDe,
      'bizrno': instance.bizrno,
    };
