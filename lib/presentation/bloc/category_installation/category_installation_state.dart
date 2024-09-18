part of 'category_installation_bloc.dart';

abstract class CategoryInstallationState {}

class CategoryInstallationInitial extends CategoryInstallationState {}

class CategoryInstallationLoading extends CategoryInstallationState {}

class CategoryInstallationLoadingCableTypes extends CategoryInstallationState {
  final CategoryInstallationState previousState;
  CategoryInstallationLoadingCableTypes(this.previousState);
}

class CategoryInstallationLoadingCategoryItems extends CategoryInstallationState {
  final CategoryInstallationState previousState;
  CategoryInstallationLoadingCategoryItems(this.previousState);
}

class CategoryInstallationLoadingItems extends CategoryInstallationState {
  final CategoryInstallationState previousState;
  CategoryInstallationLoadingItems(this.previousState);
}

class CableTypesLoaded extends CategoryInstallationState {
  final List<CableType> cableTypes;
  CableTypesLoaded(this.cableTypes);
}

class CategoryItemsLoaded extends CategoryInstallationState {
  final List<CategoryItem> categoryItems;
  CategoryItemsLoaded(this.categoryItems);
}

class ItemsLoaded extends CategoryInstallationState {
  final List<Item> items;
  ItemsLoaded(this.items);
}

class CategoryInstallationError extends CategoryInstallationState {
  final String message;
  CategoryInstallationError(this.message);
}
