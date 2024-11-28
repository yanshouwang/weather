import 'package:json/json.dart';

@JsonCodable()
class Radar {
  final String title;
  final String image;
  final String url;

  Radar({
    required this.title,
    required this.image,
    required this.url,
  });
}
