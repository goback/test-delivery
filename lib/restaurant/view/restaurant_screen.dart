import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prac/restaurant/component/restaurant_card.dart';
import 'package:prac/restaurant/view/restaurant_detail_screen.dart';
import 'package:prac/restaurant/provider/restaurant_provider.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
    itemCount: data.length,
      itemBuilder: (context, index) {
        final pItem = data[index];

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
    ),
    );
  }
}
