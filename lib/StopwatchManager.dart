// stopwatch_manager.dart
import 'dart:async';

class StopwatchManager {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Function(Duration)? onUpdate;

  StopwatchManager({this.onUpdate});

  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    Duration duration = _stopwatch.elapsed;
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      onUpdate?.call(_stopwatch.elapsed);
    });
  }

  void stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void resetStopwatch() {
    stopStopwatch();
    _stopwatch.reset();
    onUpdate?.call(_stopwatch.elapsed);
  }

  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
  }
}