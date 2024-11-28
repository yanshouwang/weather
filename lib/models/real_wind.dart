import 'package:json/json.dart';

@JsonCodable()
class RealWind {
  final String direct;
  final double degree;
  final String power;
  final double speed;

  RealWind({
    required this.direct,
    required this.degree,
    required this.power,
    required this.speed,
  });
}
