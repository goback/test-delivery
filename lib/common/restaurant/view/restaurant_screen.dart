import 'package:flutter/material.dart';
import 'package:prac/common/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: RestaurantCard(
        image: Image.asset(
          'asset/img/food/ddeok_bok_gi.jpg',
        ),
        name: '불타는 떡볶이',
        tags: ['떡볶이', '치즈', '매운맛'],
        ratingsCount: 100,
        deliveryTime: 15,
        deliveryFee: 2000,
        rating: 4.52,
      ),
    );
  }
}
