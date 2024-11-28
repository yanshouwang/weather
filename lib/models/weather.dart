import 'package:json/json.dart';

import 'air.dart';
import 'climate.dart';
import 'passed_chart.dart';
import 'predict.dart';
import 'radar.dart';
import 'real.dart';
import 'temperature_chart.dart';

@JsonCodable()
class Weather {
  final Real real;
  final Predict predict;
  final Air air;
  final List<TemperatureChart> tempchart;
  final List<PassedChart> passedchart;
  final Climate climate;
  final Radar radar;

  Weather({
    required this.real,
    required this.predict,
    required this.air,
    required this.tempchart,
    required this.passedchart,
    required this.climate,
    required this.radar,
  });
}
