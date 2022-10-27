import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prac/common/const/data.dart';
import 'package:prac/common/dio/dio.dart';
import 'package:prac/restaurant/component/restaurant_card.dart';
import 'package:prac/restaurant/model/restaurant_model.dart';
import 'package:prac/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final Dio dio = Dio();

    dio.interceptors.add(CustomInterceptor());

    final response = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'accessToken': 'true',
        },
      ),
    );

    return response.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List>(
        future: paginateRestaurant(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              final pItem = RestaurantModel.fromJson(item);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailScreen(id: pItem.id),
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
