import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketapi/screens/collection_detail_screen.dart';
import '../models/collection_model.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  late Box<CollectionModel> collectionsBox;

  @override
  void initState() {
    super.initState();
    collectionsBox = Hive.box<CollectionModel>('collectionsBox');
  }

  void _showAddCollectionDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                final newCollection = CollectionModel(
                  title: title,
                  description: descriptionController.text.trim(),
                  requests: HiveList(Hive.box('requestsBox')),
                );
                await collectionsBox.add(newCollection);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: collectionsBox.listenable(),
      builder: (context, Box<CollectionModel> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('No saved API collections yet.'));
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final collection = box.getAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionDetailScreen(collection: collection),
      ),
    );
  },
  title: Text(collection!.title),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (collection.description.isNotEmpty)
        Text(collection.description),
      Text('Requests: ${collection.requests.length}'),
    ],
  ),
  trailing: IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () async {
      await collection.delete();
    },
  ),
)

              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddCollectionDialog,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
