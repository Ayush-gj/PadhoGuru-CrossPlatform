import 'package:flutter/material.dart';
import 'models/task_model.dart';
import 'models/schedule_model.dart';
import 'models/session_model.dart';
import 'screens/classes_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/self_study_screen.dart';
import 'screens/settings_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ThemeMode currentMode;
  const MainNavigationWrapper({super.key, required this.onThemeToggle, required this.currentMode});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ScheduleItem> universitySchedule = [];
  List<Task> tasks = [];
  List<String> notes = [];
  List<Session> selfStudySessions = [];
  int priorityCount = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ClassesScreen(schedule: universitySchedule, onImport: (list) => setState(() => universitySchedule = list)),
      TasksScreen(
        tasks: tasks,
        onAdd: (t) => setState(() => tasks.add(t)),
        onToggle: (i) => setState(() => tasks[i].isCompleted = !tasks[i].isCompleted),
        onClearCompleted: () => setState(() => tasks.removeWhere((t) => t.isCompleted)),
      ),
      NotesScreen(
        notes: notes,
        onAdd: (n) => setState(() => notes.add(n)),
        onDelete: (index) => setState(() => notes.removeAt(index)),
      ),
      SelfStudyScreen(
        sessions: selfStudySessions,
        priorityCount: priorityCount,
        onUpdate: (newList, count) => setState(() { selfStudySessions = newList; priorityCount = count; }),
        onDelete: (i) => setState(() {
          if(selfStudySessions[i].subject.contains("CRUCIAL")) priorityCount--;
          selfStudySessions.removeAt(i);
        }),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
          ),
        ),
        title: const Text("PadhoGuru 📒", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 26)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)])),
              child: Center(child: Text("PadhoGuru", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
            ),
            ListTile(leading: const Icon(Icons.school_rounded), title: const Text("Classes"), onTap: () { setState(() => _selectedIndex = 0); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.task_alt_rounded), title: const Text("Tasks"), onTap: () { setState(() => _selectedIndex = 1); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.note_rounded), title: const Text("Notes"), onTap: () { setState(() => _selectedIndex = 2); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.menu_book_rounded), title: const Text("Self Study"), onTap: () { setState(() => _selectedIndex = 3); Navigator.pop(context); }),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_rounded), title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(onThemeToggle: widget.onThemeToggle, currentMode: widget.currentMode)));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school_rounded), label: 'Classes'),
          NavigationDestination(icon: Icon(Icons.task_alt_rounded), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.note_rounded), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Self Study'),
        ],
      ),
    );
  }
}