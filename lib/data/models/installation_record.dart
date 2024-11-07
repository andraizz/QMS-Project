part of 'models.dart';

class InstallationRecords {
    final int? id;
    final String? username;
    final String? dmsId;
    final String? qmsId;
    final String? servicePoint;
    final String? project;
    final String? segment;
    final String? sectionName;
    final String? area;
    final double? latitude;
    final double? longitude;
    final String? typeOfInstallation;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    InstallationRecords({
        this.id,
        this.username,
        this.dmsId,
        this.qmsId,
        this.servicePoint,
        this.project,
        this.segment,
        this.sectionName,
        this.area,
        this.latitude,
        this.longitude,
        this.typeOfInstallation,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory InstallationRecords.fromJson(Map<String, dynamic> json) => InstallationRecords(
        id: json["id"],
        username: json["username"],
        dmsId: json["dms_id"],
        qmsId: json["qms_id"],
        servicePoint: json["service_point"],
        project: json["project"],
        segment: json["segment"],
        sectionName: json["section_name"],
        area: json["area"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        typeOfInstallation: json["type_of_installation"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "dms_id": dmsId,
        "qms_id": qmsId,
        "service_point": servicePoint,
        "project": project,
        "segment": segment,
        "section_name": sectionName,
        "area": area,
        "latitude": latitude,
        "longitude": longitude,
        "type_of_installation": typeOfInstallation,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}