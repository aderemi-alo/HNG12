class Country {
  final String name;
  final String capital;
  final String? presidentName; // Nullable
  final String phoneCode;
  final String continent;
  final String population;
  final String flagUrl;
  final String statesUrl;

  Country({
    required this.name,
    required this.capital,
    this.presidentName, // Now nullable
    required this.phoneCode,
    required this.continent,
    required this.population,
    required this.flagUrl,
    required this.statesUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'], // Default value
      capital: json['capital'],
      presidentName: json['current_president']?['name']?.toString(),
      phoneCode: json['phone_code'].toString(), // Handle null
      continent: json['continent'] ?? 'Unknown Continent',
      population: json['population'].toString(),
      flagUrl: json['href']['flag'].toString(),
      statesUrl: json['href']['states'].toString(),
    );
  }
}
