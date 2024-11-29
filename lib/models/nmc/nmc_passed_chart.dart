import 'package:json/json.dart';

@JsonCodable()
class NMCPassedChart {
  final double rain1h;
  final double rain24h;
  final double rain12h;
  final double rain6h;
  final double temperature;
  final String tempDiff;
  final double humidity;
  final double pressure;
  final double windDirection;
  final double windSpeed;
  final String time;

  NMCPassedChart({
    required this.rain1h,
    required this.rain24h,
    required this.rain12h,
    required this.rain6h,
    required this.temperature,
    required this.tempDiff,
    required this.humidity,
    required this.pressure,
    required this.windDirection,
    required this.windSpeed,
    required this.time,
  });
}
