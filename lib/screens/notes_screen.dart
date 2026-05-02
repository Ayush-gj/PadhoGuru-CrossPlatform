import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final List<String> notes;
  final Function(String) onAdd;
  final Function(int) onDelete;

  const NotesScreen({super.key, required this.notes, required this.onAdd, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        shape: const CircleBorder(),
        onPressed: () => _showStickyNoteModal(context),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quick Notes 📝", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: notes.isEmpty
                  ? const Center(child: Text("No notes! Tap + to add."))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: notes.length,
                itemBuilder: (context, index) => _buildStickyNote(context, notes[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyNote(BuildContext context, String text, int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    List<Color> colors = isDark
        ? [const Color(0xFF1E293B), const Color(0xFF334155), const Color(0xFF1E293B), const Color(0xFF334155)]
        : [const Color(0xFFFEF9C3), const Color(0xFFDBEAFE), const Color(0xFFDCFCE7), const Color(0xFFFFE4E6)];

    return Stack(
      children: [
        Container(
          width: double.infinity, height: double.infinity, padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: colors[index % colors.length], borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.push_pin_rounded, size: 16, color: Colors.black26),
              const SizedBox(height: 8),
              Expanded(child: Text(text, style: TextStyle(fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF334155)))),
            ],
          ),
        ),
        Positioned(top: 5, right: 5, child: GestureDetector(onTap: () => onDelete(index), child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle), child: const Icon(Icons.close, size: 14)))),
      ],
    );
  }

  void _showStickyNoteModal(BuildContext context) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFEF9C3),
        title: const Text("Quick Note 📌", style: TextStyle(color: Colors.brown)),
        content: TextField(controller: noteCtrl, maxLines: 4, decoration: const InputDecoration(hintText: "Type...", border: InputBorder.none)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.brown), onPressed: () { if (noteCtrl.text.isNotEmpty) { onAdd(noteCtrl.text); Navigator.pop(context); } }, child: const Text("Save", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}