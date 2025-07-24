class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? profileImageUrl;
  final DateTime? birthDate;
  final String? gender;
  final int points;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.profileImageUrl,
    this.birthDate,
    this.gender,
    required this.points,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImageUrl,
    DateTime? birthDate,
    String? gender,
    int? points,
    int? level,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      points: points ?? this.points,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}