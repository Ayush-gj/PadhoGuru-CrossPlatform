import 'package:flutter/material.dart';
import 'navigation_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PadhoGuruApp());
}

class PadhoGuruApp extends StatefulWidget {
  const PadhoGuruApp({super.key});

  @override
  State<PadhoGuruApp> createState() => _PadhoGuruAppState();
}

class _PadhoGuruAppState extends State<PadhoGuruApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PadhoGuru',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: SplashScreen(onThemeToggle: _toggleTheme, currentMode: _themeMode),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final ThemeMode currentMode;
  const SplashScreen({super.key, required this.onThemeToggle, required this.currentMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          MainNavigationWrapper(onThemeToggle: widget.onThemeToggle, currentMode: widget.currentMode)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("📒", style: TextStyle(fontSize: 100)),
              SizedBox(height: 20),
              Text("PadhoGuru", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}