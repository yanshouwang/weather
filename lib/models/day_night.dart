import 'package:json/json.dart';

import 'day_night_weather.dart';
import 'day_night_wind.dart';

@JsonCodable()
class DayNight {
  final DayNightWeather weather;
  final DayNightWind wind;

  const DayNight({
    required this.weather,
    required this.wind,
  });
}
