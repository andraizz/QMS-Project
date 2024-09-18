part of 'sources.dart';

class CategoryInstallationSource {
  static const _baseURL = '${URLs.host}/api';

  Future<List<CableType>?> listCableTypes() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/cable-types'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) => CableType.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log('Failed to load cable types: ${response.statusCode}',
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

  //Method Untuk Mendapatkan Kategori Item Berdasarkan Tipe Kabel yang dipilih
  Future<List<CategoryItem>?> listCategoryItems(String cableType) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseURL/category-items/$cableType'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) => CategoryItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log('Failed to load category items: ${response.statusCode}',
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

  //Method untuk mendapatkan item berdasarkan tipe kabel dan kategori item yang dipilih
  Future<List<Item>?> listItems(String cableType, String categoryItem) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseURL/items/$cableType/$categoryItem'));
      DMethod.logResponse(response);

      if (response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        return resBody
            .map((e) => Item.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        DMethod.log('Failed to load items: ${response.statusCode}',
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
