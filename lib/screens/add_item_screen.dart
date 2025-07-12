import 'package:flutter/material.dart';
import 'package:lab_inventory/screens/scan_screen.dart';
import '../db/database_helper.dart';
import '../models/item.dart';
import 'home_screen.dart';

class AddItemScreen extends StatefulWidget {
  final String scannedCode;
  const AddItemScreen({super.key, required this.scannedCode});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeController.text = widget.scannedCode;
  }

  Future<void> saveNewItem() async {
    if (!_formKey.currentState!.validate()) return;

    final newItem = Item(
      code: codeController.text,
      name: nameController.text,
      type: typeController.text,
      status: 'Checked In',
      usageHours: 0,
      damageNotes: '',
      location: locationController.text,
    );

    await DatabaseHelper.instance.insertItem(newItem);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ScanScreen()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Code'),
                validator: (val) => val == null || val.isEmpty ? 'Enter a code' : null,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (val) => val == null || val.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Item Type'),
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: saveNewItem,
                icon: const Icon(Icons.save),
                label: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
