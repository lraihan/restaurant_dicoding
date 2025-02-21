import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/services/api_services.dart';
import 'package:restaurant_app_dicoding/views/search_result.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;

  testWidgets(
    'SearchResult displays search results',
    (WidgetTester tester) async {
      final mockApiService = MockApiService();
      final restaurantProvider = RestaurantProvider()..apiService = mockApiService;
      final themeProvider = ThemeProvider();

      when(() => mockApiService.searchRestaurants('query', any())).thenAnswer((_) async => [
            {'id': '1', 'name': 'Restaurant 1', 'city': 'City 1', 'description': 'Description 1'},
          ]);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: restaurantProvider),
            ChangeNotifierProvider.value(value: themeProvider),
          ],
          child: MaterialApp(
            home: SearchResult(query: 'query'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Restaurant 1'), findsWidgets);
    },
  );
}
