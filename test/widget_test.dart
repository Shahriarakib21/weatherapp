import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart'; // <-- notice: weather_app, not weatherapp

void main() {
  testWidgets('WeatherApp builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Check if app title or home widget exists
    expect(find.text('Weather'), findsOneWidget); // your MaterialApp title
  });
}
