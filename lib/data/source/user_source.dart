part of 'sources.dart';

class UserSource {
  static const _baseURL = '${UrlsDms.host}/PatroliApi';

  static Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer xzvOowuH6nFdXJH2dz8ZxHX2hWSR7skvbnVzdQ==',
        },
        body: {
          'user': username,
          'password': password
        },
      );
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> resBody = jsonDecode(response.body);

        if (resBody['result'] == 'nok' && resBody['data'].isEmpty) {
          DMethod.log(resBody['message'], colorCode: 1);
          return null; // Return null if login fails
        }

        if (resBody['result'] == 'ok' && resBody['data'].isNotEmpty) {
          return User.fromJson(Map.from(resBody['data'][0]));
        }
      }
      return null;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  Future<UserData?> getUsers(int userId) async{
    try {
      final uri = Uri.parse('$_baseURL/getUsers?param1=$userId');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer xzvOowuH6nFdXJH2dz8ZxHX2hWSR7skvbnVzdQ=='
      });

      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['result'] == 'ok') {
          // Assuming data is a list of users
          final data = jsonResponse['data'][0]; // Get first user from the list
          return UserData.fromJson(data);
        }
      }
    }

    catch(e) {
       if (e is http.ClientException) {
        DMethod.log('Network error: ${e.message}', colorCode: 1);
      } else {
        DMethod.log('Error: ${e.toString()}', colorCode: 1);
      }
      return null;
    }
    return null;
  }
}
