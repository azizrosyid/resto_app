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

  Future<Map<String, dynamic>> postReview(
      String id, String name, String review) async {
    final response = await client.post(
      Uri.parse('$baseUrl/review'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
    );
    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> searchRestaurant(String query) async {
    final response = await client.get(Uri.parse('$baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
