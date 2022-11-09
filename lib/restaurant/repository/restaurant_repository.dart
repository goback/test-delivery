import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac/common/const/data.dart';
import 'package:prac/common/dio/dio.dart';
import 'package:prac/common/model/cursor_pagination_model.dart';
import 'package:prac/common/model/pagination_params.dart';
import 'package:prac/restaurant/model/restaurant_detail_model.dart';
import 'package:prac/restaurant/model/restaurant_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    final dio = ref.watch<Dio>(dioProvider);
    final restaurantRepository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
    return restaurantRepository;
  },
);

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
