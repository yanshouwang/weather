import 'package:json/json.dart';

import 'month.dart';

@JsonCodable()
class Climate {
  final String time;
  final List<Month> month;

  Climate({
    required this.time,
    required this.month,
  });
}
