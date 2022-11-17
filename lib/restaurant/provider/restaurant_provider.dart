import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac/common/model/cursor_pagination_model.dart';
import 'package:prac/common/model/pagination_params.dart';
import 'package:prac/restaurant/model/restaurant_model.dart';
import 'package:prac/restaurant/repository/restaurant_repository.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>(
  (ref, id) {
    final state = ref.watch(restaurantProvider);

    if (state is! CursorPaginationModel) {
      return null;
    }

    return state.data.firstWhere((element) => element.id == id);
  },
);

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

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
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

        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      } else {
        if (state is CursorPaginationModel && !forceRefetch) {
          final pState = state as CursorPaginationModel;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      // 추가 데이터
      final response =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        // 기존 데이터
        final pState = state as CursorPaginationFetchingMore;

        state = response.copyWith(data: [
          ...pState.data,
          ...response.data,
        ]);
      } else {
        state = response;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

  void getDetail({required String id}) async {
    if (state is! CursorPaginationModel) {
      await this.paginate();
    }

    if (state is! CursorPaginationModel) {
      return;
    }

    final pState = state as CursorPaginationModel;

    final response = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? response : e).toList(),
    );
  }
}
