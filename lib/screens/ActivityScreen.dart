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

  void emptyWorkouts() {
    setState(() {
      workouts = [];
    });
  }

  void fetchActivities() async {
    setState(() {
      isLoading = true;
    });

    try {
      final jsonData = await widget.client.fetchData();

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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: emptyWorkouts,
          tooltip: 'Reset',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: fetchActivities,
            tooltip: 'Get',
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            child: ListTile(
              title: Text(workout.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Duration: ${workout.duration}',
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      'Date: ${workout.date}',
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      'Latitude: ${workout.latitude}',
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      'Longitude: ${workout.longitude}',
                      style: const TextStyle(fontSize: 12))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
