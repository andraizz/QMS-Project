part of 'sources.dart';

class CategoryItemSource {
  static const _baseURL = '${URLs.host}/api';

  Future <List<CategoryItem>?> listCategoryItems() async {
    try{
      final response = await http.get(Uri.parse('$_baseURL/list-category-items'),);
      DMethod.logResponse(response);

      if(response.statusCode == 200) {
        final List<dynamic> resBody = jsonDecode(response.body);
        
        return resBody.map((e) => CategoryItem.fromJson(Map<String, dynamic>.from(e))).toList();
      }else {
        DMethod.log('Failed to load category items: ${response.statusCode}', colorCode: 1);
        return null;
      }
    }catch(e) {
      if (e is http.ClientException) {
        DMethod.log('Network error: ${e.message}', colorCode: 1);
      } else {
        DMethod.log('Error: ${e.toString()}', colorCode: 1);
      }
      return null;
    }
  }
}