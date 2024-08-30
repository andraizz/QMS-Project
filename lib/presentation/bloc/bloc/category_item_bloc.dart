import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:qms_application/data/models/models.dart';
import 'package:qms_application/data/source/sources.dart';

part 'category_item_event.dart';
part 'category_item_state.dart';

class CategoryItemBloc extends Bloc<CategoryItemEvent, CategoryItemState> {
  final CategoryItemSource categoryItemSource;

  CategoryItemBloc({required this.categoryItemSource})
      : super(const CategoryItemInitial()) {
    on<FetchCategoryItems>(_onFetchCategoryItems);
  }

  Future<void> _onFetchCategoryItems(
      FetchCategoryItems event, Emitter<CategoryItemState> emit) async {
    emit(const CategoryItemLoading());
    try {
      final items = await categoryItemSource.listCategoryItems();
      print('Items fetched: $items'); // Debugging log
      if (items != null) {
        emit(CategoryItemLoaded(items));
      } else {
        emit(const CategoryItemFailed('Failed to fetch category items'));
      }
    } catch (e) {
      print('Error: $e'); // Debugging log
      emit(CategoryItemFailed(e.toString()));
    }
  }
}
