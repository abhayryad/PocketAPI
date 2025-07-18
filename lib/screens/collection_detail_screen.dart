import 'package:flutter/material.dart';
import 'package:pocketapi/models/collection_model.dart';

class CollectionDetailScreen extends StatelessWidget {
  final CollectionModel collection;

  const CollectionDetailScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(collection.title)),
      body: collection.requests.isEmpty
          ? const Center(child: Text('No requests in this collection yet.'))
          : ListView.builder(
              itemCount: collection.requests.length,
              itemBuilder: (context, index) {
                final request = collection.requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Text(
                      request.method,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(request.url),
                    subtitle: Text(
                      request.timestamp.toLocal().toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
