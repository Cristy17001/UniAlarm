class Weather {
  final double temp_c;
  final String condition;
  final String city;
  final String country;
  final String icon;

  Weather({
    required this.temp_c,
    required this.condition,
    required this.city,
    required this.country,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final temp_c = current['temp_c'] as double;
    final condition = current['condition']['text'] as String;
    final city = json['location']['name'];
    final country = json['location']['country'];
    final icon = convertImagePath(current['condition']['icon'] as String);
    return Weather(
      temp_c: temp_c,
      condition: condition,
      city: city,
      country: country,
      icon: icon,
    );
  }

  static String convertImagePath(String? imagePath) {
    const String apiBaseUrl = '//cdn.weatherapi.com/';
    const String assetBaseUrl = 'assets/';
    return imagePath?.replaceAll(apiBaseUrl, assetBaseUrl) ?? '';
  }

}
