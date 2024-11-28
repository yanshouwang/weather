import 'package:weather/models.dart';

import 'nmc_service.dart';

abstract interface class WeatherService {
  factory WeatherService.nmc() => NMCService();

  Future<Weather> getWeather();
}
