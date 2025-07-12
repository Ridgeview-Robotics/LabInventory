import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';
import 'home_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController locationController;
  late TextEditingController statusController;
  late TextEditingController usageHoursController;
  late TextEditingController damageNotesController;
  late TextEditingController codeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    typeController = TextEditingController(text: widget.item.type);
    locationController = TextEditingController(text: widget.item.location);
    statusController = TextEditingController(text: widget.item.status);
    usageHoursController = TextEditingController(text: widget.item.usageHours.toString());
    damageNotesController = TextEditingController(text: widget.item.damageNotes);
    codeController = TextEditingController(text: widget.item.code);
  }

  Future<void> saveChanges() async {
    final updatedItem = Item(
      code: codeController.text,
      name: nameController.text,
      type: typeController.text,
      status: statusController.text,
      usageHours: int.tryParse(usageHoursController.text) ?? 0,
      damageNotes: damageNotesController.text,
      location: locationController.text,
    );

    await DatabaseHelper.instance.updateItem(updatedItem);
    if (mounted) {
      Navigator.pop(context, true); // Pass true indicating data changed
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Item Type'),
            ),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Item Code'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: usageHoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Usage Hours'),
            ),
            TextField(
              controller: damageNotesController,
              decoration: const InputDecoration(labelText: 'Damage Notes'),
              maxLines: 3,
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