import 'package:json/json.dart';

import 'nmc_day_night_weather.dart';
import 'nmc_day_night_wind.dart';

@JsonCodable()
class NMCDayNight {
  final NMCDayNightWeather weather;
  final NMCDayNightWind wind;

  const NMCDayNight({
    required this.weather,
    required this.wind,
  });
}
