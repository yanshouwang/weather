import 'package:json/json.dart';

@JsonCodable()
class Air {
  final String forecasttime;
  final int aqi;
  final int aq;
  final String text;
  final String aqiCode;

  Air({
    required this.forecasttime,
    required this.aqi,
    required this.aq,
    required this.text,
    required this.aqiCode,
  });
}
