import 'package:flutter/material.dart';
import '../widgets/image_carousel.dart';
import '../models/country.dart';
import 'package:intl/intl.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    final imageUrls = [
      country.flagUrl,
      country.coatOfArmsUrl,
    ].where((url) => url.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
          title: Text(
        country.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrls.isNotEmpty) ImageCarousel(imageUrls: imageUrls),
            const SizedBox(height: 24),
            _buildInfoRow('Population', _formatPopulation(country.population)),
            _buildInfoRow('Region', country.region),
            _buildInfoRow('Capital', country.capital),
            SizedBox(height: 15),
            _buildInfoRow('Official Language', country.officialLanguage),
            _buildInfoRow('Currency', country.currency),
            _buildInfoRow('Dialing Code', country.dialingCode),
            _buildInfoRow('Area', '${_formatArea(country.area)} km²'),
            _buildInfoRow('Population', _formatPopulation(country.population)),
            _buildTimeZoneSection(),
          ],
        ),
      ),
    );
  }

  // Build each of the detailed information except time zones
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  // Builds time zones information
  Widget _buildTimeZoneSection() {
    final timeZones = country.timezones;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time Zones:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(width: 5),
        Text(
          timeZones.isEmpty ? 'N/A' : timeZones.join(', '),
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Allow up to 2 lines before truncating
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }

  // Formats the population to make it more readable
  String _formatPopulation(int population) {
    return NumberFormat.decimalPattern().format(population);
  }

  // Formats the area to make it more readable
  String _formatArea(double area) {
    return NumberFormat.decimalPattern().format(area);
  }
}
