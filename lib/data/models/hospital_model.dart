import 'package:json_annotation/json_annotation.dart';

part 'hospital_model.g.dart';

@JsonSerializable()
class HospitalModel {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double latitude;
  final double longitude;
  final String? category;
  final String? operatingHours;
  final List<String>? departments;
  final double? rating;
  final int? reviewCount;
  final bool isEmergencyAvailable;
  final bool isParkingAvailable;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.latitude,
    required this.longitude,
    this.category,
    this.operatingHours,
    this.departments,
    this.rating,
    this.reviewCount,
    this.isEmergencyAvailable = false,
    this.isParkingAvailable = false,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalModelFromJson(json);

  Map<String, dynamic> toJson() => _$HospitalModelToJson(this);

  HospitalModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? category,
    String? operatingHours,
    List<String>? departments,
    double? rating,
    int? reviewCount,
    bool? isEmergencyAvailable,
    bool? isParkingAvailable,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      operatingHours: operatingHours ?? this.operatingHours,
      departments: departments ?? this.departments,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isEmergencyAvailable: isEmergencyAvailable ?? this.isEmergencyAvailable,
      isParkingAvailable: isParkingAvailable ?? this.isParkingAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}