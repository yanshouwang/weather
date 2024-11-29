import 'package:json/json.dart';

@JsonCodable()
class NMCDayNightWeather {
  final String info;
  final String img;
  final String temperature;

  const NMCDayNightWeather({
    required this.info,
    required this.img,
    required this.temperature,
  });
}
