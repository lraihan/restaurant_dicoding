import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:restaurant_app_dicoding/views/restaurant_detail.dart';

class FavoriteRestaurants extends StatelessWidget {
  const FavoriteRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
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
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: blackColor.shade100),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight(context) * .01, horizontal: screenWidth(context) * .02),
                    leading: SizedBox(
                      width: screenWidth(context) * .3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: restaurant.pictureId != null
                            ? Hero(
                                tag: heroTag,
                                child: Image.network(
                                  'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    title: Text(restaurant.name ?? '-'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurant.city ?? '-'),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(restaurant.rating.toString()),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: errorColor),
                      onPressed: () {
                        restaurantProvider.removeFavorite(restaurant);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetail(
                            restaurantId: restaurant.id!,
                            heroTag: heroTag,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
