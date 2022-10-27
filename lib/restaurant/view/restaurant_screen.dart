import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prac/common/const/data.dart';
import 'package:prac/common/dio/dio.dart';
import 'package:prac/restaurant/component/restaurant_card.dart';
import 'package:prac/restaurant/model/restaurant_model.dart';
import 'package:prac/restaurant/repository/restaurant_repository.dart';
import 'package:prac/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final Dio dio = Dio();

    dio.interceptors.add(CustomInterceptor());

    RestaurantRepository restaurantRepository = RestaurantRepository(
      dio,
      baseUrl: 'http://$ip/restaurant',
    );

    final response = await restaurantRepository.paginate();

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List<RestaurantModel>>(
        future: paginateRestaurant(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final pItem = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          RestaurantDetailScreen(id: pItem.id),
                    ),
                  );
                },
                child: RestaurantCard.fromModel(pItem),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 16.0);
            },
          );
        },
      ),
    );
  }
}
