part of 'category_item_bloc.dart';

@immutable
sealed class CategoryItemState {
  const CategoryItemState();
}
//Initial
final class CategoryItemInitial extends CategoryItemState {
  const CategoryItemInitial();
}

//Loading
final class CategoryItemLoading extends CategoryItemState {
  const CategoryItemLoading();
}

//Failed
final class CategoryItemFailed extends CategoryItemState {
  final String message;

  const CategoryItemFailed(this.message);
}

//Loaded State
final class CategoryItemLoaded extends CategoryItemState {
  final List<CategoryItem> categoryItems;

  const CategoryItemLoaded(this.categoryItems);
}