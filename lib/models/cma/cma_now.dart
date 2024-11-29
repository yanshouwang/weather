import 'package:json/json.dart';

@JsonCodable()
class CMANow {
  final double precipitation;
  final double temperature;
  final double pressure;
  final double humidity;
  final String windDirection;
  final double windDirectionDegree;
  final double windSpeed;
  final String windScale;

  CMANow({
    required this.precipitation,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.windDirection,
    required this.windDirectionDegree,
    required this.windSpeed,
    required this.windScale,
  });
}
