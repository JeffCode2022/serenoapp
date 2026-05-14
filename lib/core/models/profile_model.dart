import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String dni;
  final String fullName;
  final String role;
  final String sector;
  final String? avatarUrl;

  const Profile({
    required this.id,
    required this.dni,
    required this.fullName,
    required this.role,
    required this.sector,
    this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      dni: json['dni'],
      fullName: json['full_name'],
      role: json['role'],
      sector: json['sector'] ?? 'Sector 03',
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dni': dni,
      'full_name': fullName,
      'role': role,
      'sector': sector,
      'avatar_url': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [id, dni, fullName, role, sector, avatarUrl];
}
