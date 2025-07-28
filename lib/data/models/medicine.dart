import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xml/xml.dart' as xml;
import '../../domain/entities/medicine_entity.dart';

part 'medicine.freezed.dart';
part 'medicine.g.dart';

/// 의약품 모델
@freezed
class Medicine with _$Medicine {
  const Medicine._();
  
  const factory Medicine({
    required String id,
    required String name,
    required String manufacturer,
    String? imageUrl,
    String? efficacy,
    String? usage,
    String? precautions,
    String? interactions,
    String? sideEffects,
    String? storage,
    @Default(false) bool isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    // KFDA API 전용 필드
    String? itemSeq,           // 품목일련번호
    String? itemPermitDate,    // 품목허가일자
    String? atpnWarnQesitm,    // 주의사항경고
    String? atpnQesitm,        // 주의사항
    String? openDe,            // 공개일자
    String? updateDe,          // 수정일자
    String? bizrno,            // 사업자등록번호
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
      
  /// KFDA API XML 파싱용 factory
  factory Medicine.fromXml(xml.XmlElement element) {
    String getElementText(String name) {
      try {
        return element.findElements(name).first.text.trim();
      } catch (e) {
        return '';
      }
    }

    // API 응답의 XML 요소명은 소문자임
    final itemSeq = getElementText('itemSeq');
    final itemName = getElementText('itemName');
    final entpName = getElementText('entpName');
    final itemPermitDate = getElementText('itemPermitDate');
    final efcyQesitm = getElementText('efcyQesitm');
    final useMethodQesitm = getElementText('useMethodQesitm');
    final atpnWarnQesitm = getElementText('atpnWarnQesitm');
    final atpnQesitm = getElementText('atpnQesitm');
    final intrcQesitm = getElementText('intrcQesitm');
    final seQesitm = getElementText('seQesitm');
    final depositMethodQesitm = getElementText('depositMethodQesitm');
    final openDe = getElementText('openDe');
    final updateDe = getElementText('updateDe');
    final itemImage = getElementText('itemImage');
    final bizrno = getElementText('bizrno');

    return Medicine(
      id: itemSeq.isNotEmpty ? itemSeq : DateTime.now().millisecondsSinceEpoch.toString(),
      itemSeq: itemSeq,
      name: itemName,
      manufacturer: entpName,
      imageUrl: itemImage.isNotEmpty ? itemImage : null,
      efficacy: efcyQesitm.isNotEmpty ? efcyQesitm : null,
      usage: useMethodQesitm.isNotEmpty ? useMethodQesitm : null,
      precautions: atpnQesitm.isNotEmpty ? atpnQesitm : null,
      atpnWarnQesitm: atpnWarnQesitm.isNotEmpty ? atpnWarnQesitm : null,
      atpnQesitm: atpnQesitm.isNotEmpty ? atpnQesitm : null,
      interactions: intrcQesitm.isNotEmpty ? intrcQesitm : null,
      sideEffects: seQesitm.isNotEmpty ? seQesitm : null,
      storage: depositMethodQesitm.isNotEmpty ? depositMethodQesitm : null,
      itemPermitDate: itemPermitDate.isNotEmpty ? itemPermitDate : null,
      openDe: openDe.isNotEmpty ? openDe : null,
      updateDe: updateDe.isNotEmpty ? updateDe : null,
      bizrno: bizrno.isNotEmpty ? bizrno : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  /// Convert to domain entity
  MedicineEntity toEntity() {
    return MedicineEntity(
      itemSeq: itemSeq ?? id,
      itemName: name,
      entpName: manufacturer,
      itemPermitDate: itemPermitDate,
      efcyQesitm: efficacy,
      useMethodQesitm: usage,
      atpnWarnQesitm: atpnWarnQesitm,
      atpnQesitm: atpnQesitm ?? precautions,
      intrcQesitm: interactions,
      seQesitm: sideEffects,
      depositMethodQesitm: storage,
      openDe: openDe,
      updateDe: updateDe,
      itemImage: imageUrl,
      bizrno: bizrno,
      isFavorite: isFavorite,
    );
  }
  
  /// Create from domain entity
  factory Medicine.fromEntity(MedicineEntity entity) {
    return Medicine(
      id: entity.itemSeq,
      itemSeq: entity.itemSeq,
      name: entity.itemName,
      manufacturer: entity.entpName,
      imageUrl: entity.itemImage,
      efficacy: entity.efcyQesitm,
      usage: entity.useMethodQesitm,
      precautions: entity.atpnQesitm,
      atpnWarnQesitm: entity.atpnWarnQesitm,
      atpnQesitm: entity.atpnQesitm,
      interactions: entity.intrcQesitm,
      sideEffects: entity.seQesitm,
      storage: entity.depositMethodQesitm,
      itemPermitDate: entity.itemPermitDate,
      openDe: entity.openDe,
      updateDe: entity.updateDe,
      bizrno: entity.bizrno,
      isFavorite: entity.isFavorite,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}