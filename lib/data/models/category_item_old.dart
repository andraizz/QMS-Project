part of 'models.dart';

// List<CategoryItem> categoryItemFromJson(String str) => List<CategoryItem>.from(json.decode(str).map((x) => CategoryItem.fromJson(x)));

// String categoryItemToJson(List<CategoryItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class CategoryItem {
//     final int? id;
//     final String? categoryItemCode;
//     final String? cableType;
//     final String? categoryItem;
//     final String? item;
//     final String? itemType;

//     CategoryItem({
//         this.id,
//         this.categoryItemCode,
//         this.cableType,
//         this.categoryItem,
//         this.item,
//         this.itemType,
//     });

//     factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
//         id: json["id"],
//         categoryItemCode: json["category_item_code"],
//         cableType: json["cable_type"],
//         categoryItem: json["category_item"],
//         item: json["item"],
//         itemType: json["itemType"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_item_code": categoryItemCode,
//         "cable_type": cableType,
//         "category_item": categoryItem,
//         "item": item,
//         "item_type": itemType,
//     };
// }
