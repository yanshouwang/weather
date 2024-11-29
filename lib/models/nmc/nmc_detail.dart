import 'package:json/json.dart';

import 'nmc_day_night.dart';

@JsonCodable()
class NMCDetail {
  final String date;
  final String pt;
  final NMCDayNight day;
  final NMCDayNight night;
  final double precipitation;

  const NMCDetail({
    required this.date,
    required this.pt,
    required this.day,
    required this.night,
    required this.precipitation,
  });
}
