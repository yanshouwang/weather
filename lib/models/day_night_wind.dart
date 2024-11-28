import 'package:json/json.dart';

@JsonCodable()
class DayNightWind {
  final String direct;
  final String power;

  const DayNightWind({
    required this.direct,
    required this.power,
  });
}
