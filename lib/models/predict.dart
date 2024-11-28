import 'package:json/json.dart';

import 'detail.dart';
import 'station.dart';

@JsonCodable()
class Predict {
  final Station station;
  final String publish_time;
  final List<Detail> detail;

  const Predict({
    required this.station,
    required this.publish_time,
    required this.detail,
  });
}
