import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../db/database_helper.dart';
import '../models/item.dart';
import 'item_detail_screen.dart';
import 'home_screen.dart';
import 'add_item_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> handleDetect(BarcodeCapture capture) async {
    final barcode = capture.barcodes.first;
    final code = barcode.rawValue ?? '---';

    // Stop the scanner to prevent duplicate scans
    controller.stop();

    final db = DatabaseHelper();
    final existingItem = await db.getItemByCode(code);

    if (!mounted) return; // Avoid using context if widget is disposed

    if (existingItem != null) {
      // Navigate to detail screen if item exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(item: existingItem),
        ),
      );
    } else {
      // Otherwise, navigate to AddItemScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AddItemScreen(scannedCode: code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Item")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: handleDetect,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('View All Items'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddItemScreen(scannedCode: ''),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Manual Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
