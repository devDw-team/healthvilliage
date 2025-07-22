import 'package:json_annotation/json_annotation.dart';

part 'pharmacy_model.g.dart';

@JsonSerializable()
class PharmacyModel {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double latitude;
  final double longitude;
  final String? operatingHours;
  final bool isNightPharmacy;
  final bool isHolidayOpen;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.latitude,
    required this.longitude,
    this.operatingHours,
    this.isNightPharmacy = false,
    this.isHolidayOpen = false,
    this.rating,
    this.reviewCount,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) =>
      _$PharmacyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyModelToJson(this);

  PharmacyModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? operatingHours,
    bool? isNightPharmacy,
    bool? isHolidayOpen,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PharmacyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      operatingHours: operatingHours ?? this.operatingHours,
      isNightPharmacy: isNightPharmacy ?? this.isNightPharmacy,
      isHolidayOpen: isHolidayOpen ?? this.isHolidayOpen,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}