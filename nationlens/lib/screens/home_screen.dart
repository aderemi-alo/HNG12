import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../services/api_service.dart';
// import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Country>> _countriesFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _countriesFuture = _apiService.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: _countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final countries = snapshot.data!;
                  final filteredCountries = countries
                      .where((country) => country.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Container(
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child:
                                    Image.network(country.flagUrl, width: 50)),
                            SizedBox(
                              width: 16,
                            ),
                            Text(country.name),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SizedBox(),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
