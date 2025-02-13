class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String officialLanguage;
  final String currency;
  final String dialingCode;
  final List<String> timezones;
  final double area;
  final int population;
  final String flagUrl;
  final String coatOfArmsUrl;
  final String mapUrl;

  final List<String> continents;

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.officialLanguage,
    required this.currency,
    required this.dialingCode,
    required this.timezones,
    required this.continents,
    required this.area,
    required this.population,
    required this.flagUrl,
    required this.coatOfArmsUrl,
    required this.mapUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final languages = json['languages'] as Map<String, dynamic>?;
    final currencies = json['currencies'] as Map<String, dynamic>?;
    final idd = json['idd'] as Map<String, dynamic>?;
    final coatOfArms = json['coatOfArms'] as Map<String, dynamic>?;

    return Country(
      name: json['name']?['common'] ?? 'Unknown',
      officialName: json['name']?['official'] ?? 'Unknown',
      capital: (json['capital'] as List?)?.first ?? 'No capital',
      region: json['region'] ?? 'Unknown region',
      officialLanguage: languages?.values.first ?? 'Unknown',
      currency: _formatCurrency(currencies),
      dialingCode: _formatDialCode(idd),
      timezones: List<String>.from(json['timezones'] ?? []),
      continents: List<String>.from(json['continents'] ?? []),
      area: (json['area'] as num?)?.toDouble() ?? 0,
      population: json['population'] ?? 0,
      flagUrl: json['flags']?['png'] ?? '',
      coatOfArmsUrl: coatOfArms?['png'] ?? '',
      mapUrl: json['maps']?['openStreetMaps'] ?? '',
    );
  }

  static String _formatCurrency(Map<String, dynamic>? currencies) {
    if (currencies == null || currencies.isEmpty) return 'Unknown';
    final currency = currencies.values.first;
    return '${currency['name']} (${currency['symbol'] ?? ''})'.trim();
  }

  static String _formatDialCode(Map<String, dynamic>? idd) {
    if (idd == null) return '';
    final root = idd['root'] ?? '';
    final suffixes = idd['suffixes'] as List?;

    if (suffixes == null || suffixes.isEmpty) return root;
    if (suffixes.length == 1) return '$root${suffixes.first}';
    return root;
  }
}
