class Session {
  String day, subject, time;
  bool isCrucial;
  Session({required this.day, required this.subject, required this.time, this.isCrucial = false});
}