import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onAdd;
  final Function(int) onToggle;
  final VoidCallback onClearCompleted;

  TasksScreen({super.key, required this.tasks, required this.onAdd, required this.onToggle, required this.onClearCompleted});

  @override
  Widget build(BuildContext context) {
    bool hasCompleted = tasks.any((t) => t.isCompleted);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        backgroundColor: const Color(0xFF4F46E5),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_task_rounded, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("My Tasks ✅", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                if (hasCompleted)
                  TextButton.icon(
                    onPressed: onClearCompleted,
                    icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                    label: const Text("Clear Done", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks! Add one to start."))
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => onToggle(index),
                      leading: Icon(task.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: task.isCompleted ? Colors.green : Colors.indigo),
                      title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                      subtitle: Text("${task.desc}\n${DateFormat('EEE, d MMM').format(task.date)}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("New Task 🚀", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Task Title", filled: true)),
            const SizedBox(height: 15),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description", filled: true)),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () { if (titleCtrl.text.isNotEmpty) { onAdd(Task(titleCtrl.text, descCtrl.text, DateTime.now())); Navigator.pop(context); } },
              child: const Text("Create Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}