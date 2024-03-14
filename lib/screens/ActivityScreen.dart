import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models/workout.dart';

class ActivityScreen extends StatefulWidget {
  final APIClient client;
  const ActivityScreen({Key? key, required this.client}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Workout> workouts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  void fetchActivities() async {
    try {
      const apiKey = 'QuDD0qTgxpIsOm0viZLuyCOUmRIA5pfOMwPLRCaKzZqufPgksEVq7NSLCxLkqB2b';
      final requestBody = {
        "dataSource": "Cluster0",
        "database": "Thesis",
        "collection": "workouts",
      };

      String data = await widget.client.fetchData(apiKey, requestBody);
      final jsonData = json.decode(data);

      final List<Workout> loadedWorkouts = (jsonData['documents'] as List)
          .map((document) => Workout.fromJson(document))
          .toList();

      setState(() {
        workouts = loadedWorkouts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to load workouts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(workout.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Duration: ${workout.duration}'),
                  Text('Date: ${workout.date}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
