import 'package:json/json.dart';

@JsonCodable()
class NMCRadar {
  final String title;
  final String image;
  final String url;

  NMCRadar({
    required this.title,
    required this.image,
    required this.url,
  });
}
