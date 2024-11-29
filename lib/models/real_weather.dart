class RealWeather {
  final String city;
  final double temperature;
  final double feels;
  final double lowest;
  final double highest;
  final String windDirection;
  final double windDegree;
  final double windSpeed;
  final String description;
  final String imageAssetNumber;

  RealWeather({
    required this.city,
    required this.temperature,
    required this.feels,
    required this.lowest,
    required this.highest,
    required this.windDirection,
    required this.windDegree,
    required this.windSpeed,
    required this.description,
    required this.imageAssetNumber,
  });
}
