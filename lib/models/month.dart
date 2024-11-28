import 'package:json/json.dart';

@JsonCodable()
class Month {
  final int month;
  final double maxTemp;
  final double minTemp;
  final double precipitation;

  Month({
    required this.month,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
  });
}
