import 'daily_weather.dart';
import 'hourly_weather.dart';
import 'real_weather.dart';

class Weather {
  final DateTime date;
  final RealWeather realWeather;
  final List<HourlyWeather> hourlyWeathers;
  final List<DailyWeather> dailyWeathers;

  Weather({
    required this.date,
    required this.realWeather,
    required this.hourlyWeathers,
    required this.dailyWeathers,
  });
}
