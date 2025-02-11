import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class ApiService {
  static final String? _apiKey = dotenv.env['API KEY']!;
  static const String _baseUrl = 'https://api.countryapi.dev/v1/countries';

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
