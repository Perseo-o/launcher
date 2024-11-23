import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LaunchpadApp());
}

class LaunchpadApp extends StatelessWidget {
  const LaunchpadApp({Key? key}) : super(key: key); // Qui è il cambiamento

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launchpad App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
