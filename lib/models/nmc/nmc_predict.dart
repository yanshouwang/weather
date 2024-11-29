import 'package:json/json.dart';

import 'nmc_detail.dart';
import 'nmc_station.dart';

@JsonCodable()
class NMCPredict {
  final NMCStation station;
  final String publish_time;
  final List<NMCDetail> detail;

  const NMCPredict({
    required this.station,
    required this.publish_time,
    required this.detail,
  });
}
