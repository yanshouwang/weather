import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/models.dart';
import 'package:weather/models/nmc.dart';

import 'weather_service.dart';

class NMCService implements WeatherService {
  final http.Client _client;
  final Uri _baseUri;

  NMCService()
      : _client = http.Client(),
        _baseUri = Uri.http('nmc.cn');

  @override
  Future<Weather> getWeather() async {
    final nmcWeather = await getNMCWeather();
    return Weather(
      date: DateTime.parse(nmcWeather.real.publish_time),
      realWeather: RealWeather(
        city: nmcWeather.real.station.city,
        temperature: nmcWeather.real.weather.temperature,
        feels: nmcWeather.real.weather.feelst,
        lowest: nmcWeather.tempchart[0].min_temp,
        highest: nmcWeather.tempchart[0].max_temp,
        windDirection: nmcWeather.real.wind.direct,
        windDegree: nmcWeather.real.wind.degree,
        windSpeed: nmcWeather.real.wind.speed,
        description: nmcWeather.real.weather.info,
        imageAssetNumber: getImageAssetNumber(nmcWeather.real.weather.img),
      ),
      hourlyWeathers: nmcWeather.passedchart
          .map((i) => HourlyWeather(
                date: DateTime.parse(i.time),
                temperature: i.temperature,
              ))
          .toList(),
      dailyWeathers: nmcWeather.predict.detail
          .map((i) => DailyWeather(
                date: DateTime.parse(i.date),
                description: i.day.weather.info,
                imageAssetNumber: getImageAssetNumber(i.day.weather.img),
                lowest: int.parse(i.night.weather.temperature),
                highest: int.parse(i.day.weather.temperature),
              ))
          .toList(),
    );
  }

  Future<NMCWeather> getNMCWeather() async {
    final station = await getNMCStation();
    final uri = _baseUri.resolve('rest/weather').replace(
      queryParameters: {
        'stationid': station.code,
      },
    );
    final response = await _client.get(uri);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw http.ClientException(
        'Get NMC weather failed with statusCode $statusCode',
        uri,
      );
    }
    final reply = json.decode(response.body) as Map<String, Object?>;
    final code = reply['code'] as int;
    if (code != 0) {
      throw http.ClientException(
        'Get NMC weather failed with code $code',
        uri,
      );
    }
    final item = reply['data'] as Map<String, Object?>;
    item.removeWhere((key, value) => value is String && value.isEmpty);
    return NMCWeather.fromJson(item);
  }

  Future<NMCStation> getNMCStation() async {
    final uri = _baseUri.resolve('rest/position');
    final response = await _client.get(uri);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw http.ClientException(
        'Get NMC station failed with statusCode $statusCode',
        uri,
      );
    }
    final item = json.decode(response.body) as Map<String, Object?>;
    return NMCStation.fromJson(item);
  }

  String getImageAssetNumber(String img, [bool isDay = true]) {
    // http://image.nmc.cn/static2/site/nmc/themes/basic/weather/white/day/{img}.png
    // http://image.nmc.cn/static2/site/nmc/themes/basic/weather/white/night/{img}.png
    switch (img) {
      case '0':
        return isDay ? '33' : '28';
      case '1':
        return isDay ? '04' : '08';
      case '2':
        return '01';
      case '3':
      case '36':
        return isDay ? '16' : '15';
      case '4':
        return '13';
      case '5':
      case '14':
      case '15':
      case '16':
      case '17':
      case '26':
      case '27':
      case '28':
      case '33':
        return '20';
      case '6':
        return '27';
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
        return '17';
      case '13':
        return isDay ? '30' : '29';
      case '18':
      case '32':
        return '03';
      case '20':
      case '31':
        return '24';
      case '29':
        return '26';
      case '30':
        return '23';
      default:
        return '36';
    }
  }
}
