import 'package:json/json.dart';

@JsonCodable()
class NMCDayNightWind {
  final String direct;
  final String power;

  const NMCDayNightWind({
    required this.direct,
    required this.power,
  });
}
