import 'package:clover/clover.dart';
import 'package:weather/models.dart';
import 'package:weather/services.dart';

final class HomeViewModel extends ViewModel {
  final WeatherService _weatherService;

  Weather? _weather;

  HomeViewModel()
      : _weatherService = WeatherService.cma(),
        _weather = null {
    updateWeather();
  }

  Weather? get weather => _weather;

  void updateWeather() async {
    _weather = await _weatherService.getWeather();
    notifyListeners();
  }
}
