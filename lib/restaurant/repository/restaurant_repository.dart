import 'package:dio/dio.dart' hide Headers;
import 'package:prac/common/model/cursor_pagination_model.dart';
import 'package:prac/restaurant/model/restaurant_detail_model.dart';
import 'package:prac/restaurant/model/restaurant_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPaginationModel<RestaurantModel>> paginate();


  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
