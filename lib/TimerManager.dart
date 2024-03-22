// timer_manager.dart
import 'dart:async';

class TimerManager {
  Duration _duration = Duration();
  Timer? _timer;
  Function(Duration)? onUpdate;

  TimerManager({this.onUpdate});

  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
    return '${twoDigits(_duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _duration += Duration(seconds: 1);
      onUpdate?.call(_duration);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    _duration = Duration();
    onUpdate?.call(_duration);
  }

  void dispose() {
    _timer?.cancel();
  }
}
