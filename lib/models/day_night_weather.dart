import 'package:json/json.dart';

@JsonCodable()
class DayNightWeather {
  final String info;
  final String img;
  final String temperature;

  const DayNightWeather({
    required this.info,
    required this.img,
    required this.temperature,
  });
}
