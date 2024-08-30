part of 'category_item_bloc.dart';
@immutable
sealed class CategoryItemEvent {
  const CategoryItemEvent();

  // Digunakan oleh Equatable untuk membandingkan instance
  List<Object> get props => [];
}

class FetchCategoryItems extends CategoryItemEvent {
  const FetchCategoryItems();
}