import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/review_provider.dart';

class AddReviewScreen extends StatelessWidget {
  final String restaurantId;
  final VoidCallback onReviewAdded;

  const AddReviewScreen({super.key, required this.restaurantId, required this.onReviewAdded});

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);

    final nameController = TextEditingController();
    final reviewController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: 'Review',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              reviewProvider.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await reviewProvider.addReview(
                            restaurantId,
                            nameController.text,
                            reviewController.text,
                            context,
                          );
                          onReviewAdded();
                          await Provider.of<RestaurantProvider>(context, listen: false)
                              .fetchRestaurantDetail(restaurantId, context);
                        }
                      },
                      child: Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
