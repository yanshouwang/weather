import 'package:json/json.dart';

import 'nmc_air.dart';
import 'nmc_climate.dart';
import 'nmc_passed_chart.dart';
import 'nmc_predict.dart';
import 'nmc_radar.dart';
import 'nmc_real.dart';
import 'nmc_temperature_chart.dart';

@JsonCodable()
class NMCWeather {
  final NMCReal real;
  final NMCPredict predict;
  final NMCAir air;
  final List<NMCTemperatureChart> tempchart;
  final List<NMCPassedChart> passedchart;
  final NMCClimate climate;
  final NMCRadar radar;

  NMCWeather({
    required this.real,
    required this.predict,
    required this.air,
    required this.tempchart,
    required this.passedchart,
    required this.climate,
    required this.radar,
  });
}
