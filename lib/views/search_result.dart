import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/widgets/restaurant_item.dart';
import '../models/resource.dart';

class SearchResult extends StatelessWidget {
  final String query;

  const SearchResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantProvider.searchRestaurants(query, context);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding(context),
          vertical: verticalPadding(context),
        ),
        child: Consumer<RestaurantProvider>(
          builder: (context, restaurantProvider, child) {
            final resource = restaurantProvider.restaurants;

            if (resource is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (resource is Error) {
              return Center(child: Text((resource as Error).message));
            } else if (resource is Success) {
              final restaurants = (resource as Success).data;
              if (restaurants.isEmpty) {
                return Center(child: Text('No restaurants found.'));
              }

              return ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  final heroTag = 'restaurant-image-${restaurant.id}';
                  return RestaurantItem(
                    restaurant: restaurant,
                    heroTag: heroTag,
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
