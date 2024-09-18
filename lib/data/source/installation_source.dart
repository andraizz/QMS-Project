part of 'sources.dart';

class InstallationSource {
  static const _baseURL = '${URLs.host}/api';

  Future<List<InstallationType>?> listInstallationTypes() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/installation-types'));
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

  Future<List<InstallationStep>?> listInstallationSteps(int installationTypeId ) async {
    try {
       final response =
          await http.get(Uri.parse('$_baseURL/installation-steps/?installation_type_id=$installationTypeId'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) => InstallationStep.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log('Failed to load category installation steps: ${response.statusCode}',
            colorCode: 1);
        return null;
      }
    }
    catch (e) {
      if (e is http.ClientException) {
        DMethod.log('Network error: ${e.message}', colorCode: 1);
      } else {
        DMethod.log('Error: ${e.toString()}', colorCode: 1);
      }
      return null;
    }
  }
}
