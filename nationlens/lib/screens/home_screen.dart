import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../services/api_service.dart';
import '../providers/theme_provider.dart';
import 'detail_screen.dart';
import '../widgets/filter_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Country>> _countriesFuture;
  final TextEditingController _searchController = TextEditingController();
  Set<String> _selectedContinents = {};
  Set<String> _selectedTimezones = {};
  List<String> _continents = [];
  List<String> _timezones = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Initialize countries data and extract filter options
  void _initializeData() async {
    _countriesFuture = ApiService().fetchCountries().then((countries) {
      _extractFilterOptions(countries);
      return countries;
    });
  }

  // Extract unique continents and timezones for filtering
  void _extractFilterOptions(List<Country> countries) {
    final continentSet = <String>{};
    final timezoneSet = <String>{};

    for (var country in countries) {
      continentSet.addAll(country.continents);
      timezoneSet.addAll(country.timezones);
    }

    setState(() {
      _continents = continentSet.toList()..sort();
      _timezones = timezoneSet.toList()..sort();
    });
  }

  // Group countries alphabetically with responsive layout
  Map<String, List<Country>> _groupCountries(List<Country> countries) {
    final grouped = <String, List<Country>>{};

    for (var country in countries) {
      if (country.name.isEmpty) continue;
      final firstLetter = country.name[0].toUpperCase();
      grouped.putIfAbsent(firstLetter, () => []);
      grouped[firstLetter]!.add(country);
    }

    final groupTitles = grouped.keys.toList()..sort();
    for (var title in groupTitles) {
      grouped[title]!.sort((a, b) => a.name.compareTo(b.name));
    }

    return grouped;
  }

  // Apply all active filters and search
  List<Country> _applyFilters(List<Country> countries) {
    return countries.where((country) {
      final matchesSearch = country.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      final matchesContinent = _selectedContinents.isEmpty ||
          country.continents.any((c) => _selectedContinents.contains(c));

      final matchesTimezone = _selectedTimezones.isEmpty ||
          country.timezones.any((tz) => _selectedTimezones.contains(tz));

      return matchesSearch && matchesContinent && matchesTimezone;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Phone vs tablet breakpoint

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore.'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Provider.of<ThemeProvider>(context).isDarkMode
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false)
                .toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12.0 : 24.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                // Responsive Search Bar
                _buildSearchField(isSmallScreen),
                const SizedBox(height: 8),
                // Filter Button
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildFilterButton(isSmallScreen),
                ),
              ],
            ),
          ),
          // Country List
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: _countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final filteredCountries = _applyFilters(snapshot.data!);
                final groupedCountries = _groupCountries(filteredCountries);
                final groupTitles = groupedCountries.keys.toList()..sort();

                return ListView.builder(
                  itemCount: groupTitles.length * 2,
                  itemBuilder: (context, index) {
                    if (index.isOdd) return const Divider(height: 1);

                    final groupIndex = index ~/ 2;
                    final groupTitle = groupTitles[groupIndex];
                    final countries = groupedCountries[groupTitle] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupHeader(groupTitle, isSmallScreen),
                        ...countries.map((country) =>
                            _buildCountryItem(country, isSmallScreen)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Search bar functionality
  Widget _buildSearchField(bool isSmallScreen) {
    return TextField(
      textAlign: TextAlign.center,
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search country',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: _getSearchBarColor(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 12 : 16,
          horizontal: 16,
        ),
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Color _getSearchBarColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Color.alphaBlend(
      isDark
          ? Colors.white.withOpacity(0.08) // Dark mode opacity
          : Colors.black.withOpacity(0.06), // Light mode opacity
      Theme.of(context).colorScheme.surface,
    );
  }

  // Filter Button
  Widget _buildFilterButton(bool isSmallScreen) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      child: TextButton.icon(
          icon: Icon(
            Icons.filter_alt_outlined,
            color: isDark ? Colors.white : Colors.black,
          ),
          label: Text(
            'Filter',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                width: 0.5,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          onPressed: () {
            _openFilterSheet(context);
          }),
    );
  }

  // Functionality for opening filter bottom sheet
  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        continents: _continents,
        timezones: _timezones,
        selectedContinents: _selectedContinents,
        selectedTimezones: _selectedTimezones,
        onApply: (continents, timezones) {
          setState(() {
            _selectedContinents = continents;
            _selectedTimezones = timezones;
          });
        },
      ),
    );
  }

  Widget _buildGroupHeader(String letter, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 24,
        vertical: 8,
      ),
      width: double.infinity,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCountryItem(Country country, bool isSmallScreen) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 24,
      ),
      leading: _buildCountryFlag(country, isSmallScreen),
      title: Text(
        country.name,
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        country.capital,
        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CountryDetailScreen(country: country),
        ),
      ),
    );
  }

  Widget _buildCountryFlag(Country country, bool isSmallScreen) {
    return Container(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          country.flagUrl,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => Icon(
            Icons.flag,
            size: 40,
          ),
        ),
      ),
    );
  }
}
