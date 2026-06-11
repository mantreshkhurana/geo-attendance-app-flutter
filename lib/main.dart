import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/screens.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Uses PLACEHOLDER Firebase config — auth/firestore/storage will NOT work.
  // For real Firebase: delete lib/firebase_options.dart and
  // android/app/google-services.json, then run `flutterfire configure`.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geo Attendance',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _index = 0;

  final List<Widget> _tabs = const [
    HomePage(),
    AttendancePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _tabs),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.house, size: 20),
            selectedIcon: Icon(FontAwesomeIcons.house, size: 20),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.clipboardCheck, size: 20),
            selectedIcon: Icon(FontAwesomeIcons.clipboardCheck, size: 20),
            label: 'Attendance',
          ),
        ],
      ),
    );
  }
}
