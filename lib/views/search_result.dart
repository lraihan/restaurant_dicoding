import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:restaurant_app_dicoding/views/restaurant_detail.dart';
import '../models/resource.dart';

class SearchResult extends StatelessWidget {
  final String query;

  const SearchResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantProvider.searchRestaurants(query, context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context), vertical: verticalPadding(context)),
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
            }

            return Container();
          },
        ),
      ),
    );
  }
}
