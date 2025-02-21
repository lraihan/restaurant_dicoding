import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app_dicoding/main.dart' as app;
import 'robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate to Melting Pot restaurant detail', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final navigationRobot = NavigationRobot(tester);

    expect(find.text('Restaurants you may like..'), findsOneWidget);
    await tester.pumpAndSettle();

    await navigationRobot.navigateToRestaurantDetail('Melting Pot');
    expect(find.text('Melting Pot'), findsWidgets);
  });
}
