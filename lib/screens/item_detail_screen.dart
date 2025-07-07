/// FILE: lib/screens/item_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/item.dart';
import '../db/database_helper.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController statusController;
  late TextEditingController usageHoursController;
  late TextEditingController damageNotesController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    typeController = TextEditingController(text: widget.item.type);
    statusController = TextEditingController(text: widget.item.status);
    usageHoursController = TextEditingController(text: widget.item.usageHours.toString());
    damageNotesController = TextEditingController(text: widget.item.damageNotes);
    locationController = TextEditingController(text: widget.item.location);
  }

  Future<void> saveChanges() async {
    final updatedItem = Item(
      code: widget.item.code,
      name: nameController.text,
      type: typeController.text,
      status: statusController.text,
      usageHours: int.tryParse(usageHoursController.text) ?? 0,
      damageNotes: damageNotesController.text,
      location: locationController.text,
    );

    await DatabaseHelper.instance.updateItem(updatedItem);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Code: ${widget.item.code}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: usageHoursController,
              decoration: const InputDecoration(labelText: 'Usage Hours'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: damageNotesController,
              decoration: const InputDecoration(labelText: 'Damage Notes'),
              maxLines: 2,
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
