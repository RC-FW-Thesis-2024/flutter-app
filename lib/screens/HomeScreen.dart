import 'package:flutter/material.dart';
// Make sure to import StopwatchManager instead of TimerManager
import 'package:flutter_app/StopwatchManager.dart';
import 'package:flutter_app/api_client.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final APIClient apiClient;

  const HomeScreen({Key? key, required this.apiClient}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _locationMessage = "Location not fetched yet";
  StopwatchManager? _stopwatchManager;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _stopwatchManager = StopwatchManager(
      onUpdate: (duration) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _stopwatchManager?.dispose();
    super.dispose();
  }


  Future<void> resetPosition() async {
    setState(() {
      // Reset the location message to its initial state
      _locationMessage = "No location data";
      // Set the current position to null to indicate no location is selected
      _currentPosition = null;
    });
  }

  Future<void> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _locationMessage =
      'Lat: ${position.latitude}, Long: ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.location_pin),
          onPressed: _determinePosition,
          tooltip: 'Reset',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: resetPosition,
            tooltip: 'Get',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _stopwatchManager?.formattedDuration ?? '00:00:00',
              style: const TextStyle(
                fontSize: 62,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _locationMessage,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _stopwatchManager?.startStopwatch();
                  },
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _stopwatchManager?.stopStopwatch();
                  },
                  child: Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_currentPosition != null) { // Ensure _currentPosition is not null
                  widget.apiClient.postWorkout(
                    _stopwatchManager!.formattedDuration,
                    _currentPosition!.longitude,
                    _currentPosition!.latitude// Step 3: Use the stored Position
                  );
                  _stopwatchManager?.resetStopwatch();
                } else {
                  // Handle the case where position is not available
                  print("Position is not available.");
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}