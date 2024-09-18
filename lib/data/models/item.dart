part of 'models.dart';

class Item {
  final String itemName;

  Item({required this.itemName});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item'],
    );
  }
}