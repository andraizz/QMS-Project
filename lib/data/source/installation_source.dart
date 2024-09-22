part of 'sources.dart';

class InstallationSource {
  static const _baseURL = '${URLs.host}/api';

  Future<List<InstallationType>?> listInstallationTypes() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseURL/installation-types'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) => InstallationType.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log('Failed to load installation types: ${response.statusCode}',
            colorCode: 1);
        return null;
      }
    } catch (e) {
      if (e is http.ClientException) {
        DMethod.log('Network error: ${e.message}', colorCode: 1);
      } else {
        DMethod.log('Error: ${e.toString()}', colorCode: 1);
      }
      return null;
    }
  }

  Future<List<InstallationStep>?> listInstallationSteps(
      int installationTypeId) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseURL/installation-steps/?installation_type_id=$installationTypeId'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) => InstallationStep.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log(
            'Failed to load category installation steps: ${response.statusCode}',
            colorCode: 1);
        return null;
      }
    } catch (e) {
      if (e is http.ClientException) {
        DMethod.log('Network error: ${e.message}', colorCode: 1);
      } else {
        DMethod.log('Error: ${e.toString()}', colorCode: 1);
      }
      return null;
    }
  }

  static Future<bool> stepInstallation(
    int installationStepId,
    int stepNumber,
    String qmsId,
    String qmsInstallationStepId,
    String typeOfInstallation,
    String description,
    List<XFile> photos, // Update photos to a list of File objects
    String status,
  ) async {
    try {
      var uri = Uri.parse('$_baseURL/installation-step-records');
      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['installation_step_id'] = installationStepId.toString();
      request.fields['step_number'] = stepNumber.toString();
      request.fields['qms_id'] = qmsId;
      request.fields['qms_installation_step_id'] = qmsInstallationStepId;
      request.fields['type_of_installation'] = typeOfInstallation;
      request.fields['description'] = description;
      request.fields['status'] = 'created';

      // Attach multiple photos to the request
      for (var photo in photos) {
        var stream = http.ByteStream(photo.openRead());
        var length = await photo.length();
        var multipartFile = http.MultipartFile(
          'photos[]', // This matches the key expected by the API
          stream,
          length,
          filename: photo.name, // XFile has the .name property for filenames
        );
        request.files.add(multipartFile);
      }

      // Send the request
      var response = await request.send();

      // Log the response and return success/failure
      var responseData = await http.Response.fromStream(response);
      DMethod.logResponse(responseData);

      return response.statusCode == 201;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }
}
