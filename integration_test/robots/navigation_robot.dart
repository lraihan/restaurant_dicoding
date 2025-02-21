import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class NavigationRobot {
  final WidgetTester tester;

  NavigationRobot(this.tester);

  Future<void> navigateToSearch() async {
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
  }

  Future<void> changeThemeToLight() async {
    await tester.tap(find.text('Light Theme'));
    await tester.pumpAndSettle();
  }

  Future<void> navigateToRestaurantDetail(String restaurantName) async {
    await tester.tap(find.text(restaurantName).first);
    await tester.pumpAndSettle();
  }

  Future<void> navigateToSettings() async {
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
  }

  Future<void> navigateBack() async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  }
}
