/// 병원/약국 마커 데이터 모델
class HospitalMarker {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String phoneNumber;
  final String? imageUrl;
  final String type; // 'hospital' or 'pharmacy'

  HospitalMarker({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phoneNumber,
    this.imageUrl,
    required this.type,
  });

  // JSON 변환을 위한 메서드
  factory HospitalMarker.fromJson(Map<String, dynamic> json) {
    return HospitalMarker(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'type': type,
    };
  }
} 