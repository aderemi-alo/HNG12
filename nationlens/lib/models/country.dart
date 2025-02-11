class Country {
  final String name;
  final String capital;
  final int population;
  final String flag;
  final List<String>? states;
  final String countryCode;
  final String continent;
  final String? president;

  Country({
    required this.name,
    required this.capital,
    required this.population,
    required this.flag,
    this.states,
    required this.countryCode,
    required this.continent,
    this.president,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json['name'],
        capital: json['capital'] ?? 'N/A',
        population: json['population'] ?? 0,
        flag: json['flag'],
        states:
            json['states'] != null ? List<String>.from(json['states']) : null,
        countryCode: json['countryCode'],
        continent: json['continent'],
        president: json['president'],
      );
}
