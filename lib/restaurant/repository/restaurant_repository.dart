import 'package:dio/dio.dart' hide Headers;
import 'package:prac/restaurant/model/restaurant_detail_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/{id}')
  @Headers({
    'authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNjY2NjMwOTcyLCJleHAiOjE2NjY2MzEyNzJ9.5iWdu950bQUWmXGFPNermGvQ0zJPDa3cktxTvYZFw68'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
