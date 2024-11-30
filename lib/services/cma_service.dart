import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:weather/models.dart';
import 'package:weather/models/cma.dart';

import 'weather_service.dart';

class CMAService implements WeatherService {
  final http.Client _client;
  final Uri _baseUrl;

  CMAService()
      : _client = http.Client(),
        _baseUrl = Uri.https('weather.cma.cn');

  @override
  Future<Weather> getWeather() async {
    final cmaWeather = await getCMAWeather();
    return Weather(
      date: DateTime.parse(cmaWeather.lastUpdate.replaceAll('/', '-')),
      realWeather: RealWeather(
        city: cmaWeather.location.name,
        state: getWeatherState(cmaWeather.daily[0].dayCode),
        description: cmaWeather.daily[0].dayText,
        temperature: cmaWeather.now.temperature.toInt(),
        feels: getFeels(cmaWeather.now.temperature, cmaWeather.now.windSpeed),
        lowest: cmaWeather.daily[0].low.toInt(),
        highest: cmaWeather.daily[0].high.toInt(),
        windDirection: cmaWeather.now.windDirection,
        windDegree: cmaWeather.now.windDirectionDegree.toInt(),
        windSpeed: cmaWeather.now.windSpeed.toInt(),
      ),
      // CMA doesn't support hourly weathers.
      hourlyWeathers: [],
      dailyWeathers: cmaWeather.daily
          .map((i) => DailyWeather(
                date: DateTime.parse(i.date.replaceAll('/', '-')),
                state: getWeatherState(i.dayCode),
                description: i.dayText,
                lowest: i.low.toInt(),
                highest: i.high.toInt(),
              ))
          .toList(),
    );
  }

  Future<CMAWeather> getCMAWeather() async {
    final url = _baseUrl.resolve('api/weather/view');
    final response = await _client.get(url);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw http.ClientException(
        'Get CMA weather failed with statusCode $statusCode',
        url,
      );
    }
    final reply = json.decode(response.body) as Map<String, Object?>;
    final code = reply['code'] as int;
    if (code != 0) {
      throw http.ClientException(
        'Get CMA weather failed with code $code',
        url,
      );
    }
    final item = reply['data'] as Map<String, Object?>;
    return CMAWeather.fromJson(item);
  }

  int getFeels(double temperature, double windSpeed) {
    // 体感温度(°C)＝温度(°C)-2√风速(米/每秒)。
    final feels = temperature - 2 * math.sqrt(windSpeed);
    return feels.toInt();
  }

  WeatherState getWeatherState(int code) {
    // https://weather.cma.cn/static/img/w/icon/w{code}.png
    switch (code) {
      case 0:
        return WeatherState.sunny;
      case 1:
        return WeatherState.cloudy;
      case 2:
        return WeatherState.overcast;
      case 3:
      case 36:
        return WeatherState.sunshower;
      case 4:
        return WeatherState.thundershower;
      case 5:
      case 14:
      case 15:
      case 16:
      case 17:
      case 26:
      case 27:
      case 28:
      case 33:
        return WeatherState.snowy;
      case 6:
        return WeatherState.sleety;
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 19:
      case 21:
      case 22:
      case 23:
      case 24:
      case 25:
        return WeatherState.rainy;
      case 13:
        return WeatherState.sunsnow;
      case 18:
      case 32:
        return WeatherState.foggy;
      case 20:
      case 31:
        return WeatherState.tornadic;
      case 29:
        return WeatherState.dewed;
      case 30:
        return WeatherState.windy;
      default:
        return WeatherState.unknown;
    }
  }
}
