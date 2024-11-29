import 'package:json/json.dart';

import 'cma_daily.dart';
import 'cma_location.dart';
import 'cma_now.dart';

@JsonCodable()
class CMAWeather {
  final CMALocation location;
  final List<CMADaily> daily;
  final CMANow now;
  final String lastUpdate;

  CMAWeather({
    required this.location,
    required this.daily,
    required this.now,
    required this.lastUpdate,
  });
}
