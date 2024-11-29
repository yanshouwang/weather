import 'package:json/json.dart';

import 'nmc_real_weather.dart';
import 'nmc_real_wind.dart';
import 'nmc_station.dart';

@JsonCodable()
class NMCReal {
  final NMCStation station;
  final String publish_time;
  final NMCRealWeather weather;
  final NMCRealWind wind;

  NMCReal({
    required this.station,
    required this.publish_time,
    required this.weather,
    required this.wind,
  });
}
