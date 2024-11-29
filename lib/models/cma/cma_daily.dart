import 'package:json/json.dart';

@JsonCodable()
class CMADaily {
  final String date;
  final double high;
  final String dayText;
  final int dayCode;
  final String dayWindDirection;
  final String dayWindScale;
  final double low;
  final String nightText;
  final int nightCode;
  final String nightWindDirection;
  final String nightWindScale;

  CMADaily({
    required this.date,
    required this.high,
    required this.dayText,
    required this.dayCode,
    required this.dayWindDirection,
    required this.dayWindScale,
    required this.low,
    required this.nightText,
    required this.nightCode,
    required this.nightWindDirection,
    required this.nightWindScale,
  });
}
