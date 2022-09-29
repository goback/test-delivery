import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prac/common/const/data.dart';
import 'package:prac/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final Dio dio = Dio();
    final response = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
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

              return RestaurantCard(
                image: Image.network(
                  'http://$ip/${item['thumbUrl']}',
                  fit: BoxFit.cover,
                ),
                name: item['name'],
                tags: List<String>.from(item['tags']),
                ratingsCount: item['ratingsCount'],
                deliveryTime: item['deliveryTime'],
                deliveryFee: item['deliveryFee'],
                ratings: item['ratings'],
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
