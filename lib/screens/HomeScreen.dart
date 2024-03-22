import 'package:flutter/material.dart';
import 'package:flutter_app/TimerManager.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _locationMessage = "Fetching location...";
  TimerManager? _timerManager;

  @override
  void initState() {
    super.initState();
    _timerManager = TimerManager(
      onUpdate: (duration) {
        // This callback gets called whenever the timer updates
        setState(() {});
      },
    );
    _determinePosition();
  }

  @override
  void dispose() {
    _timerManager?.dispose();
    super.dispose();
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
      _locationMessage =
      'Lat: ${position.latitude}, Long: ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _timerManager?.formattedDuration ?? '00:00:00',
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
                    _timerManager?.startTimer();
                  },
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _timerManager?.stopTimer();
                  },
                  child: Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _timerManager?.resetTimer();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}