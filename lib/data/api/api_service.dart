import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client = http.Client();

  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<dynamic>> getRestaurantList() async {
    final response = await client.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['restaurants'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getRestaurantDetail(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['restaurant'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
