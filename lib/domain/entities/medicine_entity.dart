/// 의약품 엔티티 (도메인 계층)
class MedicineEntity {
  final String itemSeq;           // 품목일련번호
  final String itemName;          // 품목명
  final String entpName;          // 업체명
  final String? itemPermitDate;   // 품목허가일자
  final String? efcyQesitm;       // 효능효과
  final String? useMethodQesitm;  // 사용법
  final String? atpnWarnQesitm;   // 주의사항경고
  final String? atpnQesitm;       // 주의사항
  final String? intrcQesitm;      // 상호작용
  final String? seQesitm;         // 부작용
  final String? depositMethodQesitm; // 보관법
  final String? openDe;           // 공개일자
  final String? updateDe;         // 수정일자
  final String? itemImage;        // 의약품이미지
  final String? bizrno;           // 사업자등록번호
  final bool isFavorite;          // 즐겨찾기 여부 (앱 내부 관리)

  const MedicineEntity({
    required this.itemSeq,
    required this.itemName,
    required this.entpName,
    this.itemPermitDate,
    this.efcyQesitm,
    this.useMethodQesitm,
    this.atpnWarnQesitm,
    this.atpnQesitm,
    this.intrcQesitm,
    this.seQesitm,
    this.depositMethodQesitm,
    this.openDe,
    this.updateDe,
    this.itemImage,
    this.bizrno,
    this.isFavorite = false,
  });
}