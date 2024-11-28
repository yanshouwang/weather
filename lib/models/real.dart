import 'package:json/json.dart';

import 'real_weather.dart';
import 'real_wind.dart';
import 'station.dart';

@JsonCodable()
class Real {
  final Station station;
  final String publish_time;
  final RealWeather weather;
  final RealWind wind;

  Real({
    required this.station,
    required this.publish_time,
    required this.weather,
    required this.wind,
  });
}
