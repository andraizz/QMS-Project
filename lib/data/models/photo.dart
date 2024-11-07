part of 'models.dart';
class Photo {
    final int? id;
    final int? installationRecordId;
    final String? photoUrl;

    Photo({
        this.id,
        this.installationRecordId,
        this.photoUrl,
    });

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        installationRecordId: json["installation_record_id"],
        photoUrl: json["photo_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "installation_record_id": installationRecordId,
        "photo_url": photoUrl,
    };
}