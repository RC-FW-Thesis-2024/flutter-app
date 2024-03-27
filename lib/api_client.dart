import 'dart:convert';
import 'package:dio/dio.dart';

class APIClient {
  final Dio dioClient;
  final String apiKey = 'QuDD0qTgxpIsOm0viZLuyCOUmRIA5pfOMwPLRCaKzZqufPgksEVq7NSLCxLkqB2b';
  final String baseUrl = 'https://eu-west-2.aws.data.mongodb-api.com/app/data-xcipb/endpoint/data/v1/action/';

  APIClient({
    Dio? dio,
  })
      : dioClient = dio ?? Dio();

  Future<dynamic> fetchData(Map<String, dynamic> requestBody) async {
    try {
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

  Future<void> postWorkout(String duration) async {
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
          "date": todayDate
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