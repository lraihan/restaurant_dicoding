import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/providers/review_provider.dart';
import 'package:restaurant_app_dicoding/services/workmanager_service.dart';
import 'package:restaurant_app_dicoding/views/restaurant_list.dart';
import 'package:restaurant_app_dicoding/theme/theme.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  } else {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => WorkmanagerService()..init()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Restaurant App Dicoding',
      theme: buildTheme(Brightness.light, themeProvider),
      darkTheme: buildTheme(Brightness.dark, themeProvider),
      themeMode: themeProvider.themeMode,
      home: FutureBuilder(
        future: _checkPendingNotifications(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return RestaurantList();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> _checkPendingNotifications(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final pendingNotifications = await NotificationService().pendingNotificationRequests();
    if (themeProvider.notificationsEnabled && pendingNotifications.isEmpty) {
      await Provider.of<WorkmanagerService>(
        context,
        listen: false,
      ).runPeriodicTask(themeProvider.notificationTime.hour, themeProvider.notificationTime.minute);
    }
  }
}
