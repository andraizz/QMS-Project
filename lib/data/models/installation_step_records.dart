part of 'models.dart';

class InstallationStepRecords {
  final int? id;
  final int? installationStepId;
  final int? stepNumber;
  final String? qmsId;
  final String? qmsInstallationStepId;
  final String? typeOfInstallation;
  final String? description;
  final String? categoryOfEnvironment;
  final String? status;
  final String? stepApproval;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? statusDate;
  final String? stepDescription;
  final List<PhotoStepInstallations>? photos;

  InstallationStepRecords({
    this.id,
    this.installationStepId,
    this.stepNumber,
    this.qmsId,
    this.qmsInstallationStepId,
    this.typeOfInstallation,
    this.description,
    this.categoryOfEnvironment,
    this.status,
    this.stepApproval,
    this.createdAt,
    this.updatedAt,
    this.statusDate,
    this.stepDescription,
    this.photos,
  });

  factory InstallationStepRecords.fromJson(Map<String, dynamic> json) =>
      InstallationStepRecords(
        id: json["id"],
        installationStepId: json["installation_step_id"],
        stepNumber: json["step_number"],
        qmsId: json["qms_id"],
        qmsInstallationStepId: json["qms_installation_step_id"],
        typeOfInstallation: json["type_of_installation"],
        description: json["description"],
        categoryOfEnvironment: json["category_of_environment"],
        status: json["status"],
        stepApproval: json["step_approval"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        statusDate: json["status_date"] == null
            ? null
            : DateTime.parse(json["status_date"]),
        stepDescription: json["step_description"],
        photos: json["photos"] == null
            ? null
            : List<PhotoStepInstallations>.from(
                json["photos"].map((x) => PhotoStepInstallations.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "installation_step_id": installationStepId,
        "step_number": stepNumber,
        "qms_id": qmsId,
        "qms_installation_step_id": qmsInstallationStepId,
        "type_of_installation": typeOfInstallation,
        "description": description,
        "category_of_environment": categoryOfEnvironment,
        "status": status,
        "step_approval": stepApproval,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status_date": statusDate?.toIso8601String(),
        "step_description": stepDescription,
        "photos": photos == null
            ? null
            : List<dynamic>.from(photos!.map((x) => x.toJson())),
      };
}
