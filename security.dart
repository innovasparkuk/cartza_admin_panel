class Session {
  String device;
  String ip;
  DateTime loginTime;

  Session({required this.device, required this.ip, required this.loginTime});
}

class LoginHistory {
  String device;
  String ip;
  DateTime timestamp;

  LoginHistory({required this.device, required this.ip, required this.timestamp});
}
