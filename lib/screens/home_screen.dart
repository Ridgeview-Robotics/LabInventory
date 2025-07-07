import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';
import 'scan_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _items = [];
  List<Item> _filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) =>
      item.name.toLowerCase().contains(query) ||
          item.code.toLowerCase().contains(query) ||
          item.type.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> loadItems() async {
    final items = await DatabaseHelper.instance.getAllItems();
    setState(() {
      _items = items;
      _filteredItems = items;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name, code, or type',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadItems,
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Code: ${item.code}\nType: ${item.type}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemDetailScreen(item: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanScreen()),
        ).then((_) => loadItems()),
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
