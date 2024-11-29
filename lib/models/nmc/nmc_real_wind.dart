import 'package:json/json.dart';

@JsonCodable()
class NMCRealWind {
  final String direct;
  final double degree;
  final String power;
  final double speed;

  NMCRealWind({
    required this.direct,
    required this.degree,
    required this.power,
    required this.speed,
  });
}
