part of 'models.dart';

class CategoryItem {
  final String categoryItem;

  CategoryItem({required this.categoryItem});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      categoryItem: json['category_item'],
    );
  }
}
