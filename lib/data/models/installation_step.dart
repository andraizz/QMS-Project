part of 'models.dart';

class InstallationStep {
    final int? id;
    final int? installationTypeId;
    final int? stepNumber;
    final String? stepDescription;
    final int? imageLength;

    InstallationStep({
        this.id,
        this.installationTypeId,
        this.stepNumber,
        this.stepDescription,
        this.imageLength
    });

    factory InstallationStep.fromJson(Map<String, dynamic> json) => InstallationStep(
        id: json["id"],
        installationTypeId: json["installation_type_id"],
        stepNumber: json["step_number"],
        stepDescription: json["step_description"],
        imageLength: json["image_length"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "installation_type_id": installationTypeId,
        "step_number": stepNumber,
        "step_description": stepDescription,
        "image_length": imageLength,
    };
}