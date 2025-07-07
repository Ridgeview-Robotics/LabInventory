/// FILE: lib/screens/add_item_screen.dart

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';

class AddItemScreen extends StatefulWidget {
  final String scannedCode;
  const AddItemScreen({super.key, required this.scannedCode});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> saveNewItem() async {
    if (!_formKey.currentState!.validate()) return;

    final newItem = Item(
      code: widget.scannedCode,
      name: nameController.text,
      type: typeController.text,
      status: 'Checked In',
      usageHours: 0,
      damageNotes: '',
      location: locationController.text,
    );

    await DatabaseHelper.instance.insertItem(newItem);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Code: ${widget.scannedCode}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
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
