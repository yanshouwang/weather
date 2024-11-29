import 'package:json/json.dart';

@JsonCodable()
class NMCStation {
  final String code;
  final String province;
  final String city;
  final String url;

  const NMCStation({
    required this.code,
    required this.province,
    required this.city,
    required this.url,
  });
}
