import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session_model.dart';

class SelfStudyScreen extends StatefulWidget {
  final List<Session> sessions;
  final int priorityCount;
  final Function(List<Session>, int) onUpdate;
  final Function(int) onDelete;

  const SelfStudyScreen({super.key, required this.sessions, required this.priorityCount, required this.onUpdate, required this.onDelete});

  @override
  State<SelfStudyScreen> createState() => _SelfStudyScreenState();
}

class _SelfStudyScreenState extends State<SelfStudyScreen> {
  final TextEditingController _topicController = TextEditingController();
  String selectedDay = "MON";
  String selectedCategory = "Study";
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);

  final List<String> weekDays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  final List<String> categories = ["Study", "Practice", "Crucial"];

  bool _isSessionLive(String timeRange, String sessionDay) {
    try {
      String currentDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();
      if (currentDay != sessionDay) return false;
      final now = DateTime.now();
      final parts = timeRange.split(' - ');
      final format = DateFormat.jm();
      DateTime start = format.parse(parts[0]);
      DateTime end = format.parse(parts[1]);
      final startDT = DateTime(now.year, now.month, now.day, start.hour, start.minute);
      final endDT = DateTime(now.year, now.month, now.day, end.hour, end.minute);
      return now.isAfter(startDT) && now.isBefore(endDT);
    } catch (e) { return false; }
  }

  @override
  void initState() {
    super.initState();
    selectedDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: _showNewSessionModal,
        label: const Text("New Goal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.bolt, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Performance Dashboard ⚡", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatCard("Total Sessions", "${widget.sessions.length}", const Color(0xFF6366F1), Icons.book_rounded),
                  const SizedBox(width: 15),
                  _buildStatCard("High Priority", "${widget.priorityCount}", const Color(0xFFEC4899), Icons.star_rounded),
                ],
              ),
              const SizedBox(height: 30),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.sessions.length,
                itemBuilder: (ctx, i) {
                  final s = widget.sessions[i];
                  bool isLive = _isSessionLive(s.time, s.day);
                  bool crucial = s.subject.contains("CRUCIAL");
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(Icons.timer, color: crucial ? Colors.red : Colors.indigo),
                      title: Text(s.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${s.day} • ${s.time}"),
                      trailing: Wrap(
                        spacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (isLive) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)), child: const Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                          IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => widget.onDelete(i)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  void _showNewSessionModal() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text("Plan Session 🚀", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),
                const Text("Select Day", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weekDays.length,
                    itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () => setModalState(() => selectedDay = weekDays[i]),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedDay == weekDays[i] ? const Color(0xFF4F46E5) : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(weekDays[i], style: TextStyle(color: selectedDay == weekDays[i] ? Colors.white : Colors.indigo, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Focus Category", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 10,
                  children: categories.map((cat) => ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    onSelected: (val) => setModalState(() => selectedCategory = cat),
                    selectedColor: const Color(0xFF6366F1),
                  )).toList(),
                ),
                const SizedBox(height: 15),
                TextField(controller: _topicController, decoration: const InputDecoration(labelText: "Topic Name", filled: true)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text("Start Time"),
                        subtitle: Text(startTime.format(ctx)),
                        onTap: () async {
                          TimeOfDay? p = await showTimePicker(context: ctx, initialTime: startTime);
                          if (p != null) setModalState(() => startTime = p);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("End Time"),
                        subtitle: Text(endTime.format(ctx)),
                        onTap: () async {
                          TimeOfDay? p = await showTimePicker(context: ctx, initialTime: endTime);
                          if (p != null) setModalState(() => endTime = p);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      if (_topicController.text.isNotEmpty) {
                        List<Session> newList = List.from(widget.sessions);
                        int count = widget.priorityCount;
                        if (selectedCategory == "Crucial") count++;
                        newList.add(Session(
                            day: selectedDay,
                            subject: "[${selectedCategory.toUpperCase()}] ${_topicController.text}",
                            time: "${startTime.format(ctx)} - ${endTime.format(ctx)}"
                        ));
                        widget.onUpdate(newList, count);
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text("Save Session", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}