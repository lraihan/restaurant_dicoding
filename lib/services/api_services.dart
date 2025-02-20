import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restaurant_app_dicoding/widgets/snackbar.dart';

class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  final Dio _dio;
  final DefaultCacheManager _cacheManager = DefaultCacheManager();
  final Map<String, dynamic> _dataCache = {};

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: Duration(milliseconds: 10000),
            receiveTimeout: Duration(milliseconds: 8000),
          ),
        );

  void _handleError(DioException error, BuildContext context) {
    String errorMessage;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection Timeout Exception';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send Timeout Exception';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive Timeout Exception';
        break;
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            errorMessage = 'Bad Request';
            break;
          case 401:
            errorMessage = 'Unauthorized';
            break;
          case 403:
            errorMessage = 'Forbidden';
            break;
          case 404:
            errorMessage = 'Not Found';
            break;
          case 500:
            errorMessage = 'Internal Server Error';
            break;
          default:
            errorMessage = 'Received invalid status code: ${error.response?.statusCode}';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request to API server was cancelled';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Connection to API server failed due to internet connection';
        break;
      default:
        errorMessage = 'Unexpected error occurred';
    }
    CustomSnackbar.showSnackbar(context, errorMessage);
    throw Exception(errorMessage);
  }

  Future<List<dynamic>> getListOfRestaurants(BuildContext? context) async {
    const cacheKey = 'restaurant_list';
    if (_dataCache.containsKey(cacheKey)) {
      return _dataCache[cacheKey];
    }

    try {
      final response = await _dio.get('/list');
      if (response.statusCode == 200) {
        _dataCache[cacheKey] = response.data['restaurants'];
        return response.data['restaurants'];
      } else {
        if (context != null) {
          CustomSnackbar.showSnackbar(context, 'Failed to load restaurants');
        }
        throw Exception('Failed to load restaurants');
      }
    } on DioException catch (error) {
      if (context != null) {
        _handleError(error, context);
      }
    } catch (e) {
      if (context != null) {
        CustomSnackbar.showSnackbar(context, 'Failed to load restaurants: $e');
      }
      throw Exception('Failed to load restaurants: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>> getRestaurantDetail(String id, BuildContext context) async {
    final cacheKey = 'restaurant_detail_$id';

    try {
      final response = await _dio.get('/detail/$id');
      if (response.statusCode == 200) {
        _dataCache[cacheKey] = response.data['restaurant'];
        return response.data['restaurant'];
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } on DioException catch (error) {
      _handleError(error, context);
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed to load restaurant detail: $e');
      throw Exception('Failed to load restaurant detail: $e');
    }
    return {};
  }

  Future<List<dynamic>> searchRestaurants(String query, BuildContext context) async {
    try {
      final response = await _dio.get('/search?q=$query');
      if (response.statusCode == 200) {
        return response.data['restaurants'];
      } else {
        throw Exception('Failed to search restaurants');
      }
    } on DioException catch (error) {
      _handleError(error, context);
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed to search restaurants: $e');
      throw Exception('Failed to search restaurants: $e');
    }
    return [];
  }

  Future<List<dynamic>> addReview(String id, String name, String review, BuildContext context) async {
    final response = await _dio.post(
      '/review',
      data: {
        'id': id,
        'name': name,
        'review': review,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 201) {
      return response.data['customerReviews'];
    } else {
      CustomSnackbar.showSnackbar(context, 'ASDASDASDASDASDAS $response');
      throw Exception('Failed to add review');
    }
  }

  Future<String> getRestaurantPicture(String pictureId, BuildContext context) async {
    try {
      final response = await _dio.get('/images/medium/$pictureId');
      if (response.statusCode == 200) {
        return response.realUri.toString();
      } else {
        throw Exception('Failed to load restaurant picture');
      }
    } on DioException catch (error) {
      _handleError(error, context);
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed to load restaurant picture: $e');
      throw Exception('Failed to load restaurant picture: $e');
    }
    return '';
  }

  Future<File> getCachedImage(String url) async {
    return await _cacheManager.getSingleFile(url);
  }
}
