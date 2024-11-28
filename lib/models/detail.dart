import 'package:json/json.dart';

import 'day_night.dart';

@JsonCodable()
class Detail {
  final String date;
  final String pt;
  final DayNight day;
  final DayNight night;
  final double precipitation;

  const Detail({
    required this.date,
    required this.pt,
    required this.day,
    required this.night,
    required this.precipitation,
  });
}
