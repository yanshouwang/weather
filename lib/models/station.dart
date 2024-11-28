import 'package:json/json.dart';

@JsonCodable()
class Station {
  final String code;
  final String province;
  final String city;
  final String url;

  const Station({
    required this.code,
    required this.province,
    required this.city,
    required this.url,
  });
}
