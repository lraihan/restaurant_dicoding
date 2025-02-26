import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/widgets/restaurant_item.dart';

class FavoriteRestaurants extends StatelessWidget {
  const FavoriteRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Restaurants')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context), vertical: verticalPadding(context)),
        child: Consumer<RestaurantProvider>(
          builder: (context, restaurantProvider, child) {
            final favorites = restaurantProvider.favorites;

            if (favorites.isEmpty) {
              return Center(child: Text('No favorite restaurants found.'));
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                final heroTag = 'restaurant-image-${restaurant.id}';
                return RestaurantItem(
                  restaurant: restaurant,
                  heroTag: heroTag,
                  onDelete: () {
                    restaurantProvider.removeFavorite(restaurant);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
