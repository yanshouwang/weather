import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather/models.dart';

import 'weather_service.dart';

class NMCService implements WeatherService {
  final http.Client _client;
  final Uri _baseUri;

  NMCService()
      : _client = http.Client(),
        _baseUri = Uri.http('nmc.cn');

  @override
  Future<Weather> getWeather() async {
    final station = await getStation();
    final uri = _baseUri.resolve('rest/weather').replace(
      queryParameters: {
        'stationid': station.code,
      },
    );
    final response = await _client.get(uri);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw HttpException(
        'Get weather failed with statusCode $statusCode',
        uri: uri,
      );
    }
    final reply = json.decode(response.body) as Map<String, Object?>;
    final code = reply['code'] as int;
    if (code != 0) {
      throw HttpException(
        'Get weather failed with code $code',
        uri: uri,
      );
    }
    final item = reply['data'] as Map<String, Object?>;
    item.removeWhere((key, value) => value is String && value.isEmpty);
    return Weather.fromJson(item);
  }

  Future<Station> getStation() async {
    final uri = _baseUri.resolve('rest/position');
    final response = await _client.get(uri);
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw HttpException(
        'Get station failed with statusCode $statusCode',
        uri: uri,
      );
    }
    final item = json.decode(response.body) as Map<String, Object?>;
    return Station.fromJson(item);
  }
}
