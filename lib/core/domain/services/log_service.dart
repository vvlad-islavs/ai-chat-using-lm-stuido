import 'package:flutter/cupertino.dart';

class LogService extends ChangeNotifier {
  final List<Log> _logs = [];

  List<Log> get logs => List.from(_logs);

  void addLog({required Log log}) {
    _logs.add(log);
    notifyListeners();
  }

  void resetLogs() {
    _logs.clear();
    notifyListeners();
  }
}

class Log {
  final String name;
  final String message;

  Log({required this.name, required this.message});
}
