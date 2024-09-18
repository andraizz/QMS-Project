import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qms_application/data/models/models.dart';
import 'package:qms_application/data/source/sources.dart';

part 'category_installation_event.dart';
part 'category_installation_state.dart';

class CategoryInstallationBloc extends Bloc<CategoryInstallationEvent, CategoryInstallationState> {
  final CategoryInstallationSource source;

  CategoryInstallationBloc(this.source) : super(CategoryInstallationInitial()) {
    on<FetchCableTypes>(_onFetchCableTypes);
    on<FetchCategoryItems>(_onFetchCategoryItems);
    on<FetchItems>(_onFetchItems);
  }

   Future<void> _onFetchCableTypes(
    FetchCableTypes event, 
    Emitter<CategoryInstallationState> emit,
  ) async {
    emit(CategoryInstallationLoadingCableTypes(state));
    final cableTypes = await source.listCableTypes();
    if (cableTypes != null) {
      emit(CableTypesLoaded(cableTypes));
    } else {
      emit(CategoryInstallationError('Failed to load cable types.'));
    }
  }

  Future<void> _onFetchCategoryItems(
    FetchCategoryItems event, 
    Emitter<CategoryInstallationState> emit,
  ) async {
    if (state is CableTypesLoaded || state is ItemsLoaded || state is CategoryItemsLoaded) {
      emit(CategoryInstallationLoadingCategoryItems(state));
    } else {
      emit(CategoryInstallationLoading());
    }
    final categoryItems = await source.listCategoryItems(event.cableType);
    if (categoryItems != null) {
      emit(CategoryItemsLoaded(categoryItems));
    } else {
      emit(CategoryInstallationError('Failed to load category items.'));
    }
  }

  Future<void> _onFetchItems(
    FetchItems event, 
    Emitter<CategoryInstallationState> emit,
  ) async {
    if (state is CableTypesLoaded || state is CategoryItemsLoaded) {
      emit(CategoryInstallationLoadingItems(state));
    } else {
      emit(CategoryInstallationLoading());
    }
    final items = await source.listItems(event.cableType, event.categoryItem);
    if (items != null) {
      emit(ItemsLoaded(items));
    } else {
      emit(CategoryInstallationError('Failed to load items.'));
    }
  }
}
