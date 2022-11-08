import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac/restaurant/model/restaurant_model.dart';
import 'package:prac/restaurant/repository/restaurant_repository.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
  (ref) {
    final repository =
        ref.watch<RestaurantRepository>(restaurantRepositoryProvider);
    return RestaurantStateNotifier(repository: repository);
  },
);

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository}) : super([]) {
    paginate();
  }

  void paginate() async {
    final response = await repository.paginate();
    state = response.data;
  }
}
