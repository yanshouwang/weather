import 'package:json/json.dart';

@JsonCodable()
class NMCAir {
  final String forecasttime;
  final int aqi;
  final int aq;
  final String text;
  final String aqiCode;

  NMCAir({
    required this.forecasttime,
    required this.aqi,
    required this.aq,
    required this.text,
    required this.aqiCode,
  });
}
