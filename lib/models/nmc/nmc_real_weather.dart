import 'package:json/json.dart';

@JsonCodable()
class NMCRealWeather {
  final double temperature;
  final double temperatureDiff;
  final double airpressure;
  final double humidity;
  final double rain;
  final int rcomfort;
  final int icomfort;
  final String info;
  final String img;
  final double feelst;

  NMCRealWeather({
    required this.temperature,
    required this.temperatureDiff,
    required this.airpressure,
    required this.humidity,
    required this.rain,
    required this.rcomfort,
    required this.icomfort,
    required this.info,
    required this.img,
    required this.feelst,
  });
}
