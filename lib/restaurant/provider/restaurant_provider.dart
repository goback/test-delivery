import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac/common/model/cursor_pagination_model.dart';
import 'package:prac/restaurant/repository/restaurant_repository.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository =
        ref.watch<RestaurantRepository>(restaurantRepositoryProvider);
    return RestaurantStateNotifier(repository: repository);
  },
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository})
      : super(
          CursorPaginationLoading(),
        ) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    if (state is CursorPaginationModel && !forceRefetch) {
      final pState = state as CursorPaginationModel;

      if (!pState.meta.hasMore) {
        return;
      }
    }
  }
}
