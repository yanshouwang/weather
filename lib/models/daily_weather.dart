class DailyWeather {
  final DateTime date;
  final String description;
  final String imageAssetNumber;
  final int lowest;
  final int highest;

  DailyWeather({
    required this.date,
    required this.description,
    required this.imageAssetNumber,
    required this.lowest,
    required this.highest,
  });
}
