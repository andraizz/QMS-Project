part of 'models.dart';

class CableType {
  final String cableType;

  CableType({required this.cableType});

  factory CableType.fromJson(Map<String, dynamic> json) {
    return CableType(
      cableType: json['cable_type'],
    );
  }
}