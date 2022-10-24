import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prac/common/const/data.dart';
import 'package:prac/common/layout/default_layout.dart';
import 'package:prac/product/component/product_card.dart';
import 'package:prac/restaurant/component/restaurant_card.dart';
import 'package:prac/restaurant/model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final dio = Dio();

    final response = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(headers: {
        'authorization': 'Bearer $accessToken',
      }),
    );

    return response.data;
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: products.length,
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: products[index]),
            );
          },
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      body: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final item = RestaurantDetailModel.fromJson(snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(model: item),
              renderLabel(),
              renderProducts(products: item.products),
            ],
          );
        },
      ),
    );
  }
}
