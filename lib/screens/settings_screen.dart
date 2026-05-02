import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ThemeMode currentMode;

  const SettingsScreen({super.key, required this.onThemeToggle, required this.currentMode});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode;

  // New Feature States
  String selectedStartScreen = "Classes";
  bool is24HourFormat = false;
  double alertLeadTime = 10.0;
  bool isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.currentMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryIndigo = const Color(0xFF4F46E5);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // --- APPEARANCE SECTION ---
          _buildSectionHeader("Appearance"),
          SwitchListTile(
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: primaryIndigo),
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch between light and dark themes"),
            value: isDarkMode,
            onChanged: (val) {
              setState(() { isDarkMode = val; });
              widget.onThemeToggle(val);
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time, color: primaryIndigo),
            title: const Text("24-Hour Format"),
            trailing: Switch(
              value: is24HourFormat,
              onChanged: (val) => setState(() => is24HourFormat = val),
            ),
          ),

          const Divider(),

          // --- ACADEMIC PREFERENCES ---
          _buildSectionHeader("Academic Preferences"),
          ListTile(
            leading: Icon(Icons.home_work_outlined, color: primaryIndigo),
            title: const Text("Default Start Screen"),
            subtitle: Text("Currently: $selectedStartScreen"),
            onTap: _showStartScreenPicker,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Class Alert Lead Time", style: TextStyle(fontWeight: FontWeight.w500)),
                    Text("${alertLeadTime.toInt()} mins before", style: TextStyle(color: primaryIndigo, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: alertLeadTime,
                  min: 0, max: 60,
                  divisions: 12,
                  activeColor: primaryIndigo,
                  onChanged: (val) => setState(() => alertLeadTime = val),
                ),
              ],
            ),
          ),

          const Divider(),

          // --- PRIVACY & SECURITY ---
          _buildSectionHeader("Privacy & Security"),
          SwitchListTile(
            secondary: Icon(Icons.fingerprint, color: primaryIndigo),
            title: const Text("Biometric Lock"),
            subtitle: const Text("Require fingerprint to open PadhoGuru"),
            value: isBiometricEnabled,
            onChanged: (val) => setState(() => isBiometricEnabled = val),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text("Reset App Data", style: TextStyle(color: Colors.redAccent)),
            onTap: () => _showResetConfirmation(context),
          ),

          const Divider(),

          // --- SYSTEM INFO ---
          _buildSectionHeader("About PadhoGuru"),
          const ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Creation Date"),
            trailing: Text("January 2026"),
          ),
          const ListTile(
            leading: Icon(Icons.verified_user_outlined),
            title: Text("Privacy Status"),
            trailing: Text("Local & Secure"),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Version"),
            trailing: Text("1.0.5 Pro"),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4F46E5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showStartScreenPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ["Classes", "Tasks", "Notes", "Self Study"].map((screen) => ListTile(
          title: Text(screen),
          onTap: () {
            setState(() => selectedStartScreen = screen);
            Navigator.pop(ctx);
          },
        )).toList(),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset Everything?"),
        content: const Text("This will permanently delete all your schedules, tasks, and notes."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("RESET", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}