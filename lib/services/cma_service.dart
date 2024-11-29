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
        temperature: cmaWeather.now.temperature,
        feels: getFeels(cmaWeather.now.temperature, cmaWeather.now.windSpeed),
        lowest: cmaWeather.daily[0].low,
        highest: cmaWeather.daily[0].high,
        windDirection: cmaWeather.now.windDirection,
        windDegree: cmaWeather.now.windDirectionDegree,
        windSpeed: cmaWeather.now.windSpeed,
        description: cmaWeather.daily[0].dayText,
        imageAssetNumber: getImageAssetNumber(cmaWeather.daily[0].dayCode),
      ),
      // CMA doesn't support hourly weathers.
      hourlyWeathers: [],
      dailyWeathers: cmaWeather.daily
          .map((i) => DailyWeather(
                date: DateTime.parse(i.date.replaceAll('/', '-')),
                description: i.dayText,
                imageAssetNumber: getImageAssetNumber(i.dayCode),
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

  double getFeels(double temperature, double windSpeed) {
    // 体感温度(°C)＝温度(°C)-2√风速(米/每秒)。
    final feels = temperature - 2 * math.sqrt(windSpeed);
    final feelsValue = feels.toStringAsFixed(1);
    return double.parse(feelsValue);
  }

  String getImageAssetNumber(int code, [bool isDay = true]) {
    // https://weather.cma.cn/static/img/w/icon/w{code}.png
    switch (code) {
      case 0:
        return isDay ? '33' : '28';
      case 1:
        return isDay ? '04' : '08';
      case 2:
        return '01';
      case 3:
      case 36:
        return isDay ? '16' : '15';
      case 4:
        return '13';
      case 5:
      case 14:
      case 15:
      case 16:
      case 17:
      case 26:
      case 27:
      case 28:
      case 33:
        return '20';
      case 6:
        return '27';
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
        return '17';
      case 13:
        return isDay ? '30' : '29';
      case 18:
      case 32:
        return '03';
      case 20:
      case 31:
        return '24';
      case 29:
        return '26';
      case 30:
        return '23';
      default:
        return '36';
    }
  }
}
