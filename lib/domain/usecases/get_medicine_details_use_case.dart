import '../../data/models/medicine.dart';
import '../repositories/medicine_repository.dart';

class GetMedicineDetailsUseCase {
  final MedicineRepository _repository;

  GetMedicineDetailsUseCase(this._repository);

  Future<Medicine?> execute(String itemSeq) async {
    if (itemSeq.isEmpty) {
      throw ArgumentError('itemSeq cannot be empty');
    }

    try {
      // 의약품 상세 정보 조회
      final medicine = await _repository.getMedicineDetail(itemSeq);
      
      if (medicine == null) {
        throw Exception('Medicine not found with itemSeq: $itemSeq');
      }

      return medicine;
    } catch (e) {
      print('Error in GetMedicineDetailsUseCase: $e');
      rethrow;
    }
  }
}