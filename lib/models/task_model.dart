class Task {
  String title, desc;
  DateTime date;
  bool isCompleted;
  Task(this.title, this.desc, this.date, {this.isCompleted = false});
}