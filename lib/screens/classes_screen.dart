import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as ex;
import '../models/schedule_model.dart';

class ClassesScreen extends StatelessWidget {
  final List<ScheduleItem> schedule;
  final Function(List<ScheduleItem>) onImport;

  const ClassesScreen({super.key, required this.schedule, required this.onImport});

  Future<void> _importExcel(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
          withData: true
      );

      if (result != null) {
        var bytes = result.files.first.bytes!;
        var excel = ex.Excel.decodeBytes(bytes);
        List<ScheduleItem> imported = [];

        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet == null) continue;

          for (int i = 1; i < sheet.maxRows; i++) {
            var row = sheet.rows[i];
            if (row.length >= 2 && row[0]?.value != null && row[1]?.value != null) {
              String subject = row[0]!.value.toString().trim();
              String time = row[1]!.value.toString().trim();

              // Room (Column C / Index 2)
              String room = (row.length > 2 && row[2]?.value != null)
                  ? row[2]!.value.toString().trim()
                  : "N/A";

              // Teacher (Column D / Index 3)
              String teacher = (row.length > 3 && row[3]?.value != null)
                  ? row[3]!.value.toString().trim()
                  : "Not Assigned";

              imported.add(ScheduleItem(subject, time, room, teacher));
            }
          }
        }

        if (imported.isNotEmpty) {
          onImport(imported);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Timetable Synced Successfully!"), backgroundColor: Color(0xFF4F46E5)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error reading file")));
    }
  }

  // Function to show details when a class is clicked
  void _showClassDetails(BuildContext context, ScheduleItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Class Details 📝", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
            const SizedBox(height: 20),
            _detailRow(Icons.book_outlined, "Subject", item.subject),
            _detailRow(Icons.access_time_rounded, "Time", item.time),
            _detailRow(Icons.meeting_room_outlined, "Room Number", item.room),
            _detailRow(Icons.person_outline_rounded, "Subject Teacher", item.teacher),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4F46E5), size: 28),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Classes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(today, style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w600)),
                  ],
                ),
                // Clear Screen Option
                if (schedule.isNotEmpty)
                  IconButton(
                    onPressed: () => onImport([]), // Clears the list
                    icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 28),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Import Button with Text
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => _importExcel(context),
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text("Import Excel Timetable", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: schedule.isEmpty
                  ? Center(child: Icon(Icons.table_view_rounded, size: 80, color: Colors.grey.withValues(alpha: 0.2)))
                  : ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (ctx, i) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListTile(
                    onTap: () => _showClassDetails(context, schedule[i]), // Click to show details
                    leading: const CircleAvatar(backgroundColor: Color(0xFFEEF2FF), child: Icon(Icons.school_rounded, color: Color(0xFF4F46E5))),
                    title: Text(schedule[i].subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(schedule[i].time), // Only Time shown here
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}