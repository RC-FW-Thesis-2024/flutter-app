import 'dart:convert';

import 'package:http/http.dart' as http;

class APIClient {
  final String baseUrl;
  final http.Client httpClient;

  APIClient({required this.baseUrl, http.Client? client})
      : httpClient = client ?? http.Client();

  Future<String> fetchData(String apiKey, Map<String, dynamic> requestBody) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Request-Headers': '*',
        'api-key': apiKey,
      },
      body: jsonEncode(requestBody), // Pass the body as a Map which gets encoded to JSON
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch data: ${response.body}');
    }
  }
}