part of 'category_installation_bloc.dart';

abstract class CategoryInstallationEvent {}

class FetchCableTypes extends CategoryInstallationEvent {}

class FetchCategoryItems extends CategoryInstallationEvent {
  final String cableType;
  FetchCategoryItems(this.cableType);
}

class FetchItems extends CategoryInstallationEvent {
  final String cableType;
  final String categoryItem;
  FetchItems(this.cableType, this.categoryItem);
}
