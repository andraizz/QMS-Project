part of '../sources.dart';

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

  static Future<bool> stepInstallation({
    int? installationStepId,
    int? stepNumber,
    String? qmsId,
    String? qmsInstallationStepId,
    String? typeOfInstallation,
    String? categoryOfEnvironment,
    String? description,
    List<XFile>? photos,
    String? status,
  }) async {
    try {
      var uri = Uri.parse('$_baseURL/installation-step-records');
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Add text fields
      request.fields['installation_step_id'] =
          installationStepId?.toString() ?? '';
      request.fields['step_number'] = stepNumber?.toString() ?? '';
      request.fields['qms_id'] = qmsId ?? '';
      request.fields['qms_installation_step_id'] = qmsInstallationStepId ?? '';
      request.fields['type_of_installation'] = typeOfInstallation ?? '';
      request.fields['category_of_environment'] = categoryOfEnvironment ?? '';
      request.fields['description'] = description ?? '';
      request.fields['status'] = 'created';

      // Attach multiple photos to the request
      for (var photo in photos!) {
        // Get the original file name using the `path` package
        String originalFileName = path.basename(photo.path);
        var stream = http.ByteStream(photo.openRead());
        var length = await photo.length();

        var multipartFile = http.MultipartFile(
          'photos[]', // This matches the key expected by the API
          stream,
          length,
          filename:
              originalFileName, // Use the original file name from path package
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

  static Future<Map<String, dynamic>?> installationRecords({
    String? username,
    String? dmsId,
    String? servicePoint,
    String? project,
    String? segment,
    String? sectionName,
    String? area,
    String? latitude,
    String? longitude,
    String? typeOfInstallation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/installation-records'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "username": username,
          "dms_id": dmsId,
          "service_point": servicePoint,
          "project": project,
          "segment": segment,
          "section_name": sectionName,
          "area": area,
          "latitude": latitude,
          "longitude": longitude,
          "type_of_installation": typeOfInstallation,
          "status": "Created",
        }),
      );

      DMethod.logResponse(response);

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Kembalikan map dari respons
      } else {
        return null; // Gagal
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null; // Gagal
    }
  }

  static Future<Map<String, dynamic>?> generateQMSInstallationStepId(
      {String? qmsId}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/generate-step-installation-id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"qms_id": qmsId}),
      );

      DMethod.logResponse(response);

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Kembalikan map dari respons
      } else {
        return null; // Gagal
      }
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null; // Gagal
    }
  }

  Future<InstallationRecords?> getInstallationRecord(String qmsId) async {
    try {
      final response = await http.get(
          Uri.parse('$_baseURL/installation-records/get-qms?qms_id=$qmsId'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        // Parse respons menjadi Map
        final resBody = jsonDecode(response.body) as Map<String, dynamic>;

        // Akses installation_record dari resBody
        final installationRecordData =
            resBody['installation_record'] as Map<String, dynamic>;

        // Buat instance dari InstallationRecords menggunakan fromJson
        return InstallationRecords.fromJson(installationRecordData);
      } else {
        DMethod.log(
            'Failed to load installation record get qms: ${response.statusCode}',
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

  Future<List<InstallationStepRecords>?> getInstallationStepRecords(
      String qmsId) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseURL/getInstallationStepRecordsByQmsId?qms_id=$qmsId'));

      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) =>
                InstallationStepRecords.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log(
            'Failed to load Installation Step Records : ${response.statusCode}',
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

  static Future<bool> submitInstallationRecord({
    required String qmsId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseURL/installation-records/status/submitted/$qmsId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "submitted_date": DateTime.now().toIso8601String(),
        }),
      );

      DMethod.logResponse(response);

      return response.statusCode == 200; // Check for a successful status code
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false; // Return false if there is an exception
    }
  }

  static Future<bool> submitInstallationStepRecord({
    required String qmsId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse(
            '$_baseURL/installation-step-records/status/submitted/$qmsId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "submitted_date": DateTime.now().toIso8601String(),
          "status_date": DateTime.now().toIso8601String(),
        }),
      );

      DMethod.logResponse(response);

      return response.statusCode == 200; // Check for a successful status code
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false; // Return false if there is an exception
    }
  }

  Future<List<InstallationRecords>?> getInstallationRecordByUsername(
      String username) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseURL/installation-records/username?username=$username'));

      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) =>
                InstallationRecords.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception("Installation History Empty");
      } else {
        DMethod.log(
            'Failed to load Installation Step Records : ${response.statusCode}',
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
}
