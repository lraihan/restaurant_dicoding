import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/providers/review_provider.dart';
import 'package:restaurant_app_dicoding/views/restaurant_list.dart';
import 'package:restaurant_app_dicoding/theme/theme.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(),
        ),
      ],
      child: const MyApp(),
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
      home: RestaurantList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
