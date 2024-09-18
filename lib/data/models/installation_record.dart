part of 'models.dart';

class InstallationTicketQms {
    final int? id;
    final String? qmsId;
    final int? installationStepId;
    final String? username;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Photo>? photos;

    InstallationTicketQms({
        this.id,
        this.qmsId,
        this.installationStepId,
        this.username,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.photos,
    });

    factory InstallationTicketQms.fromJson(Map<String, dynamic> json) => InstallationTicketQms(
        id: json["id"],
        qmsId: json["qms_id"],
        installationStepId: json["installation_step_id"],
        username: json["username"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "qms_id": qmsId,
        "installation_step_id": installationStepId,
        "username": username,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
    };
}