import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/models.dart';
import 'package:weather/models/nmc.dart';

import 'weather_service.dart';

class NMCService implements WeatherService {
  final http.Client _client;
  final Uri _baseUrl;
  final Uri _corsUrl;

  NMCService()
      : _client = http.Client(),
        _baseUrl = Uri.http('nmc.cn'),
        _corsUrl = Uri.https('cors.hebei.dev');

  @override
  Future<Weather> getWeather() async {
    final nmcWeather = await getNMCWeather();
    return Weather(
      date: DateTime.parse(nmcWeather.real.publish_time),
      realWeather: RealWeather(
        city: nmcWeather.real.station.city,
        state: getWeatherState(nmcWeather.real.weather.img),
        description: nmcWeather.real.weather.info,
        temperature: nmcWeather.real.weather.temperature.toInt(),
        feels: nmcWeather.real.weather.feelst.toInt(),
        lowest: nmcWeather.tempchart[0].min_temp.toInt(),
        highest: nmcWeather.tempchart[0].max_temp.toInt(),
        windDirection: nmcWeather.real.wind.direct,
        windDegree: nmcWeather.real.wind.degree.toInt(),
        windSpeed: nmcWeather.real.wind.speed.toInt(),
      ),
      hourlyWeathers: nmcWeather.passedchart
          .map((i) => HourlyWeather(
                date: DateTime.parse(i.time),
                temperature: i.temperature.toInt(),
              ))
          .toList(),
      dailyWeathers: nmcWeather.predict.detail
          .map((i) => DailyWeather(
                date: DateTime.parse(i.date),
                state: getWeatherState(i.day.weather.img),
                description: i.day.weather.info,
                lowest: int.parse(i.night.weather.temperature),
                highest: int.parse(i.day.weather.temperature),
              ))
          .toList(),
    );
  }

  Future<NMCWeather> getNMCWeather() async {
    final station = await getNMCStation();
    final apiurl = _baseUrl.resolve('rest/weather').replace(
      queryParameters: {
        'stationid': station.code,
      },
    );
    final url = _corsUrl.replace(
      queryParameters: {
        'apiurl': '$apiurl',
      },
    );
    final response = await _client.get(url);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw http.ClientException(
        'Get NMC weather failed with statusCode $statusCode',
        url,
      );
    }
    final reply = json.decode(response.body) as Map<String, Object?>;
    final code = reply['code'] as int;
    if (code != 0) {
      throw http.ClientException(
        'Get NMC weather failed with code $code',
        url,
      );
    }
    final item = reply['data'] as Map<String, Object?>;
    item.removeWhere((key, value) => value is String && value.isEmpty);
    return NMCWeather.fromJson(item);
  }

  Future<NMCStation> getNMCStation() async {
    final apiurl = _baseUrl.resolve('rest/position');
    final url = _corsUrl.replace(
      queryParameters: {
        'apiurl': '$apiurl',
      },
    );
    final response = await _client.get(url);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw http.ClientException(
        'Get NMC station failed with statusCode $statusCode',
        url,
      );
    }
    final item = json.decode(response.body) as Map<String, Object?>;
    return NMCStation.fromJson(item);
  }

  WeatherState getWeatherState(String img) {
    // http://image.nmc.cn/static2/site/nmc/themes/basic/weather/white/day/{img}.png
    // http://image.nmc.cn/static2/site/nmc/themes/basic/weather/white/night/{img}.png
    switch (img) {
      case '0':
        return WeatherState.sunny;
      case '1':
        return WeatherState.cloudy;
      case '2':
        return WeatherState.overcast;
      case '3':
      case '36':
        return WeatherState.sunshower;
      case '4':
        return WeatherState.thundershower;
      case '5':
      case '14':
      case '15':
      case '16':
      case '17':
      case '26':
      case '27':
      case '28':
      case '33':
        return WeatherState.snowy;
      case '6':
        return WeatherState.sleety;
      case '7':
      case '8':
      case '9':
      case '10':
      case '11':
      case '12':
      case '19':
      case '21':
      case '22':
      case '23':
      case '24':
      case '25':
        return WeatherState.rainy;
      case '13':
        return WeatherState.sunsnow;
      case '18':
      case '32':
        return WeatherState.foggy;
      case '20':
      case '31':
        return WeatherState.tornadic;
      case '29':
        return WeatherState.dewed;
      case '30':
        return WeatherState.windy;
      default:
        return WeatherState.unknown;
    }
  }
}
