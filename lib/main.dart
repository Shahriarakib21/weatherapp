import 'package:flutter/material.dart';
import 'package:weather_app/theme/app_theme.dart';
import 'package:weather_app/weather_home_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const WeatherHomeScreen(),
    );
  }
}
