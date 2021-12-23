import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _hour = 0;
  int _second = 0;
  int _minute = 0;
  bool _startEnable = true;
  bool _stopEnable = false;
  bool _continueEnable = false;

  int get hour => _hour;
  int get minute => _minute;
  int get second => _second;

  bool get startEnable => _startEnable;
  bool get stopEnable => _stopEnable;
  bool get continueEnable => _continueEnable;
  int get getTickTimer => _timer?.tick ?? 0;

  void tickTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_second < 59) {
          _second++;
        } else {
          _second = 0;
          if (_minute == 59) {
            _minute == 0;
            _hour++;
          } else {
            _minute++;
          }
        }
        notifyListeners();
      },
    );
  }

  void startTimer() {
    _hour = _minute = _second = 0;
    _continueEnable = _startEnable = false;
    _stopEnable = true;
    if (_timer?.isActive == true) _timer?.cancel();
    tickTimer();
  }

  void stopTimer() {
    if (_startEnable == false) {
      _startEnable = _continueEnable = true;
      _stopEnable = false;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void continueTimer() {
    //check this function
    if (_timer?.isActive == true) _timer?.cancel();
    _startEnable = _continueEnable = false;
    _stopEnable = true;
    tickTimer();
  }

  String getString() {
    String time = "";
    if (_hour != 0) {
      time += _hour.toString() + ":";
    }
    if (_minute != 0) {
      if (_hour != 0 && _minute < 10) time += "0";
      time += _minute.toString() + ":";
    }
    if (_second < 10) {
      time += "0";
    }
    time += _second.toString();
    return time;
  }
}
