import 'weather_state.dart';

class RealWeather {
  final String city;
  final WeatherState state;
  final String description;
  final int temperature;
  final int feels;
  final int lowest;
  final int highest;
  final String windDirection;
  final int windDegree;
  final int windSpeed;

  RealWeather({
    required this.city,
    required this.state,
    required this.description,
    required this.temperature,
    required this.feels,
    required this.lowest,
    required this.highest,
    required this.windDirection,
    required this.windDegree,
    required this.windSpeed,
  });
}
