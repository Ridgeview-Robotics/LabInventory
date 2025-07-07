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
  bool _found = false;

  void handleDetect(BuildContext context, BarcodeCapture capture) async {
    if (_found) return;

    final code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _found = true);

    final item = await DatabaseHelper.instance.getItemByCode(code);

    if (!context.mounted) return;

    if (item != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(item: item),
        ),
      );
    } else {
      // Code not found — route to AddItemScreen
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
      appBar: AppBar(title: const Text('Scan Item')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.normal,
              ),
              onDetect: (capture) => handleDetect(context, capture),
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
