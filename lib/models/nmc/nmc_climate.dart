import 'package:json/json.dart';

import 'nmc_month.dart';

@JsonCodable()
class NMCClimate {
  final String time;
  final List<NMCMonth> month;

  NMCClimate({
    required this.time,
    required this.month,
  });
}
