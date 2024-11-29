import 'package:json/json.dart';

@JsonCodable()
class NMCTemperatureChart {
  final String time;
  final double min_temp;
  final double max_temp;
  final String day_img;
  final String day_text;
  final String night_img;
  final String night_text;

  NMCTemperatureChart({
    required this.time,
    required this.min_temp,
    required this.max_temp,
    required this.day_img,
    required this.day_text,
    required this.night_img,
    required this.night_text,
  });
}
