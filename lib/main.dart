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
    const fontFamily = 'RotondaC';
    const appBarTheme = AppBarTheme(
      centerTitle: true,
    );
    const textTheme = TextTheme(
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
      bodyMedium: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
    final iconButtonTheme = IconButtonThemeData(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
    );
    const dividerTheme = DividerThemeData(
      space: 44.0,
      thickness: 0.5,
      indent: 16.0,
      endIndent: 16.0,
    );
    return MaterialApp.router(
      routerConfig: routerConfig,
      title: 'Weather',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: WeatherColors.front2,
          onSurface: WeatherColors.front1,
          surfaceTint: Colors.transparent,
          primary: WeatherColors.front1,
          onPrimary: WeatherColors.front2,
          outline: WeatherColors.front1,
          outlineVariant: WeatherColors.front1,
          shadow: WeatherColors.shadow,
        ),
        fontFamily: fontFamily,
        appBarTheme: appBarTheme,
        textTheme: textTheme,
        iconButtonTheme: iconButtonTheme,
        dividerTheme: dividerTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          surface: WeatherColors.front1,
          onSurface: WeatherColors.dr,
          surfaceTint: Colors.transparent,
          primary: WeatherColors.dr,
          onPrimary: WeatherColors.front1,
          outline: WeatherColors.front2.withOpacity(0.3),
          outlineVariant: WeatherColors.front2.withOpacity(0.3),
          shadow: WeatherColors.shadow,
        ),
        fontFamily: fontFamily,
        appBarTheme: appBarTheme,
        textTheme: textTheme,
        iconButtonTheme: iconButtonTheme,
        dividerTheme: dividerTheme,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: true,
      debugShowMaterialGrid: false,
    );
  }
}
