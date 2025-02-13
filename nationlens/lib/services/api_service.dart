import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

// Gets the countries and their information from the API
class ApiService {
  Future<List<Country>> fetchCountries() async {
    final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }
}
