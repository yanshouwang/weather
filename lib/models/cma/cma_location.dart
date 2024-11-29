import 'package:json/json.dart';

@JsonCodable()
class CMALocation {
  final String id;
  final String name;
  final String path;
  final double longitude;
  final double latitude;
  final int timezone;

  CMALocation({
    required this.id,
    required this.name,
    required this.path,
    required this.longitude,
    required this.latitude,
    required this.timezone,
  });
}
