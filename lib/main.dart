import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'router.dart';
import 'widgets.dart';

void main() {
  Logger.root.onRecord.listen(onLogRecord);
  runApp(const MyApp());
}

void onLogRecord(LogRecord record) {
  log(
    record.message,
    time: record.time,
    sequenceNumber: record.sequenceNumber,
    level: record.level.value,
    name: record.loggerName,
    zone: record.zone,
    error: record.error,
    stackTrace: record.stackTrace,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: WeatherColors.front2,
          onSurface: WeatherColors.front1,
          primary: WeatherColors.front2,
          onPrimary: WeatherColors.front1,
          secondary: WeatherColors.front1.withOpacity(0.6),
          outline: WeatherColors.front1,
          outlineVariant: WeatherColors.front1,
          shadow: WeatherColors.shadow,
        ),
        fontFamily: 'RotondaC',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 120.0,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        dividerTheme: const DividerThemeData(
          space: 60.0,
          thickness: 0.5,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: WeatherColors.front1,
          onSurface: WeatherColors.dr,
          primary: WeatherColors.front1,
          onPrimary: WeatherColors.dr,
          secondary: WeatherColors.front2.withOpacity(0.3),
          outline: WeatherColors.front2.withOpacity(0.3),
          outlineVariant: WeatherColors.front2.withOpacity(0.3),
          shadow: WeatherColors.shadow,
        ),
        fontFamily: 'RotondaC',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 120.0,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        dividerTheme: const DividerThemeData(
          space: 60.0,
          thickness: 0.5,
        ),
      ),
      routerConfig: routerConfig,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
    );
  }
}
