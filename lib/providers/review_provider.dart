import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/services/api_services.dart';
import 'package:restaurant_app_dicoding/widgets/snackbar.dart';

class ReviewProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addReview(String restaurantId, String name, String review, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService().addReview(restaurantId, name, review, context);
      CustomSnackbar.showSnackbar(context, 'Review Added Successfully');
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed to add review: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
