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
  late TextEditingController usageController;
  late TextEditingController damageController;

  String status = "Checked In";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    typeController = TextEditingController(text: widget.item.type);
    usageController = TextEditingController(text: widget.item.usageHours.toString());
    damageController = TextEditingController(text: widget.item.damageNotes);
    status = widget.item.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    usageController.dispose();
    damageController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    final updated = Item(
      id: widget.item.id,
      code: widget.item.code,
      name: nameController.text,
      type: typeController.text,
      status: status,
      usageHours: int.tryParse(usageController.text) ?? 0,
      damageNotes: damageController.text,
    );

    await DatabaseHelper.instance.updateItem(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated')),
      );
      Navigator.pop(context); // return to home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
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
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['Checked In', 'Checked Out'].map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => status = val);
              },
            ),
            TextField(
              controller: usageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Usage Hours'),
            ),
            TextField(
              controller: damageController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Damage Notes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
