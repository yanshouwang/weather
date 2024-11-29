import 'package:json/json.dart';

@JsonCodable()
class NMCMonth {
  final int month;
  final double maxTemp;
  final double minTemp;
  final double precipitation;

  NMCMonth({
    required this.month,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
  });
}
