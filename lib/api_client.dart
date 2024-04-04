import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIClient {
  final Dio dioClient;
  late final String apiKey;
  late final String baseUrl;

  APIClient({
    Dio? dio,
  }) : dioClient = dio ?? Dio() {
    apiKey = dotenv.env['API_KEY'] ?? "default_api_key";
    baseUrl = dotenv.env['DB_URL'] ?? "default_base_url";
  }


  Future<dynamic> fetchData() async {
    try {

      final requestBody = {
        "dataSource": "Cluster0",
        "database": "Thesis",
        "collection": "workouts",
      };

      final response = await dioClient.post(
        "${baseUrl}find",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'api-key': apiKey,
          },
        ),
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch data: Status code ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('DioError occurred: ${e.message}');
    }
  }

  Future<void> postWorkout(String duration, double longitude, double latitude) async {
    String todayDate = DateTime.now().toString(); //

    final response = await dioClient.post(
      "${baseUrl}insertOne",
      options: Options(
        headers: {
          'content-type': 'application/json',
          'api-key': apiKey,
        },
      ),
      data: jsonEncode({
        "dataSource": "Cluster0",
        "database": "Thesis",
        "collection": "post_workouts",
        "document": {
          "title": "Morning Run",
          "duration": duration,
          "date": todayDate,
          "latitude": latitude,
          "longitude": longitude,
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
     return;
    } else {
      throw Exception('Failed to post workout: ${response.data}');
    }
  }
}