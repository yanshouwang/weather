import 'weather_state.dart';

class DailyWeather {
  final DateTime date;
  final WeatherState state;
  final String description;
  final int lowest;
  final int highest;

  DailyWeather({
    required this.date,
    required this.state,
    required this.description,
    required this.lowest,
    required this.highest,
  });
}
