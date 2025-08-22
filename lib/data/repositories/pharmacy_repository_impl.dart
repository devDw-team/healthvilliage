import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../models/pharmacy_model.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final Dio _dio;
  final String _baseUrl = 'http://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList';
  final String _apiKey = 'YOUR_API_KEY'; // 실제 API 키로 교체 필요
  final SupabaseClient _supabase = Supabase.instance.client;

  PharmacyRepositoryImpl(this._dio);

  @override
  Future<List<PharmacyModel>> searchPharmacies({
    required int pageNo,
    required int numOfRows,
    String? sidoCd,
    String? sgguCd,
    String? yadmNm,
    double? xPos,
    double? yPos,
    double? radius,
  }) async {
    try {
      final queryParams = {
        'serviceKey': _apiKey,
        'pageNo': pageNo.toString(),
        'numOfRows': numOfRows.toString(),
      };

      if (sidoCd != null) queryParams['sidoCd'] = sidoCd;
      if (sgguCd != null) queryParams['sgguCd'] = sgguCd;
      if (yadmNm != null) queryParams['yadmNm'] = yadmNm;
      if (xPos != null) queryParams['xPos'] = xPos.toString();
      if (yPos != null) queryParams['yPos'] = yPos.toString();
      if (radius != null) queryParams['radius'] = radius.toString();

      final response = await _dio.get(
        _baseUrl,
        queryParameters: queryParams,
      );

      final document = xml.XmlDocument.parse(response.data);
      final items = document.findAllElements('item');
      
      final pharmacies = <PharmacyModel>[];
      
      for (final item in items) {
        final pharmacy = PharmacyModel.fromXml(item);
        
        // Supabase에 약국 정보 저장 또는 업데이트
        final savedPharmacy = await _saveOrUpdatePharmacyInSupabase(pharmacy);
        pharmacies.add(savedPharmacy);
      }
      
      return pharmacies;
    } catch (e) {
      throw Exception('약국 검색 실패: $e');
    }
  }

  Future<PharmacyModel> _saveOrUpdatePharmacyInSupabase(PharmacyModel pharmacy) async {
    try {
      // ykiho로 기존 약국 검색
      final existingPharmacy = await _supabase
          .from('pharmacies')
          .select()
          .eq('ykiho', pharmacy.ykiho ?? '')
          .maybeSingle();

      if (existingPharmacy != null) {
        // 기존 약국이 있으면 UUID 사용
        return pharmacy.copyWith(id: existingPharmacy['id'] as String);
      } else {
        // 새 약국 정보 저장
        final newPharmacy = await _supabase
            .from('pharmacies')
            .insert({
              'ykiho': pharmacy.ykiho,
              'name': pharmacy.name,
              'address': pharmacy.address,
              'phone': pharmacy.phone,
              'latitude': pharmacy.latitude,
              'longitude': pharmacy.longitude,
              'operating_hours': {},
              'is_night_pharmacy': false,
              'is_holiday_open': false,
            })
            .select()
            .single();

        return pharmacy.copyWith(id: newPharmacy['id'] as String);
      }
    } catch (e) {
      // 오류 발생 시 원본 반환
      print('Supabase 저장 오류: $e');
      return pharmacy;
    }
  }

  @override
  Future<List<PharmacyModel>> getNearbyPharmacies(
    double latitude,
    double longitude, {
    double radius = 1000,
  }) async {
    return searchPharmacies(
      pageNo: 1,
      numOfRows: 20,
      xPos: longitude,
      yPos: latitude,
      radius: radius,
    );
  }
}