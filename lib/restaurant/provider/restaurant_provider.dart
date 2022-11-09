import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac/common/model/cursor_pagination_model.dart';
import 'package:prac/common/model/pagination_params.dart';
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

    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;

    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }

    PaginationParams paginationParams = PaginationParams(count: fetchCount);

    if (fetchMore) {
      final pState = state as CursorPaginationModel;

      state = CursorPaginationFetchingMore(
        meta: pState.meta,
        data: pState.data,
      );

      paginationParams = paginationParams.copyWith(after: pState.data.last.id);
    }

    // 추가 데이터
    final response = await repository.paginate(paginationParams: paginationParams);

    if (state is CursorPaginationFetchingMore) {
      // 기존 데이터
      final pState = state as CursorPaginationFetchingMore;

      state = response.copyWith(data: [
        ...pState.data,
        ...response.data,
      ]);
    }
  }
}
