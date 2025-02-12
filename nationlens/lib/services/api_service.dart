import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class ApiService {
  static final String? _token = dotenv.env['API_TOKEN'];
  static const String _baseUrl = 'https://restfulcountries.com/api/v1';

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/countries'),
      headers: _headers(),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchStates(String statesUrl) async {
    final response = await http.get(
      Uri.parse(statesUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['data'] as List)
          .map((state) => state['name'].toString())
          .toList();
    } else {
      throw Exception('Failed to load states: ${response.statusCode}');
    }
  }

  Map<String, String> _headers() => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      };
}
