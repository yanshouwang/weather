import 'package:weather/models.dart';

import 'cma_service.dart';
import 'nmc_service.dart';

abstract interface class WeatherService {
  factory WeatherService.cma() => CMAService();
  factory WeatherService.nmc() => NMCService();

  Future<Weather> getWeather();
}
