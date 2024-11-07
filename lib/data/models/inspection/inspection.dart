part of '../models.dart';

class Inspection {
  final String username;
  final String dmsTicket;
  final String project;
  final String segment;
  final String sectionName;
  final String sectionPatrol;
  final String servicePoint;
  final String worker;
  final String statusTicket;
  final String qmsTicket;
  final DateTime? submittedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Inspection({
    required this.username,
    required this.dmsTicket,
    required this.project,
    required this.segment,
    required this.sectionName,
    required this.sectionPatrol,
    required this.servicePoint,
    required this.worker,
    required this.statusTicket,
    required this.qmsTicket,
    this.submittedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      username: json['username'],
      dmsTicket: json['dms_ticket'],
      project: json['project'],
      segment: json['segment'],
      sectionName: json['section_name'],
      sectionPatrol: json['section_patrol'],
      servicePoint: json['service_point'],
      worker: json['worker'],
      statusTicket: json['status_ticket'],
      qmsTicket: json['qms_ticket'],
      submittedDate: json['submitted_date'] != null
          ? DateTime.parse(json['submitted_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class AssetTaggingInspection {
  String nama;
  int status;
  String idInspection;
  int findingCount;

  AssetTaggingInspection({
    required this.nama,
    required this.status,
    required this.idInspection,
    this.findingCount = 0,
  });

  factory AssetTaggingInspection.fromJson(Map<String, dynamic> json) {
    return AssetTaggingInspection(
      nama: json['nama'],
      status: json['status'],
      idInspection: json['id_inspection'],
      findingCount: json['finding_count'] ?? 0,
    );
  }
}

class InspectionResponse {
  final List<Inspection> inspections;
  final List<AssetTaggingInspection> assetTagging;

  InspectionResponse({required this.inspections, required this.assetTagging});

  factory InspectionResponse.fromJson(Map<String, dynamic> json) {
    return InspectionResponse(
      inspections: (json['inspections'] as List)
          .map((item) => Inspection.fromJson(item))
          .toList(),
      assetTagging: (json['asset_tagging'] as List)
          .map((item) => AssetTaggingInspection.fromJson(item))
          .toList(),
    );
  }
}
