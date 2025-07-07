import 'package:flutter/material.dart';
import 'package:lab_inventory/screens/scan_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Inventory',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ScanScreen(),



    );



  }


}
