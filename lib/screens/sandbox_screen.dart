import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/collection_model.dart';
import '../models/request_model.dart';
import 'response_screen.dart';

class SandboxScreen extends StatefulWidget {
  const SandboxScreen({super.key});

  @override
  State<SandboxScreen> createState() => _SandboxScreenState();
}

class _SandboxScreenState extends State<SandboxScreen>
    with TickerProviderStateMixin {
  String selectedMethod = 'GET';
  final List<String> httpMethods = [
    'GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS'
  ];

  List<CollectionModel> collections = [];
  String selectedCollection = 'One-time Request';

  final TextEditingController urlController = TextEditingController();
  final List<Map<String, String>> headers = [];
  final List<Map<String, String>> params = [];

  String bodyType = 'Raw';
  String languageType = 'JSON';
  final TextEditingController bodyController = TextEditingController();

  late TabController _tabController;
  late Box<CollectionModel> collectionsBox;
  late Box<RequestModel> requestsBox;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    collectionsBox = Hive.box<CollectionModel>('collectionsBox');
    requestsBox = Hive.box<RequestModel>('requestsBox');
    _loadCollections();
  }

  void _loadCollections() {
    final hiveCollections = collectionsBox.values.toList();
    setState(() {
      collections = hiveCollections;
    });
  }

  void _showKeyValueDialog(String title, void Function(String, String) onAdd) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('New $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(labelText: 'Key'),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Value'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty) {
                onAdd(keyController.text, valueController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showNewCollectionDialog() {
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
                  requests: HiveList(requestsBox),
                );
                await collectionsBox.add(newCollection);
                _loadCollections();
                setState(() {
                  selectedCollection = title;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _runRequest() async {
    if (urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }

    if (selectedCollection != 'One-time Request') {
      // Save request to Hive
      final newRequest = RequestModel(
        method: selectedMethod,
        url: urlController.text.trim(),
        headers: [...headers],
        params: [...params],
        body: bodyController.text.trim(),
        timestamp: DateTime.now(),
      );

      final requestKey = await requestsBox.add(newRequest);
      final targetCollection = collections.firstWhere((c) => c.title == selectedCollection);

      targetCollection.requests.add(requestsBox.get(requestKey)!);
      await targetCollection.save();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResponseScreen(
          method: selectedMethod,
          url: urlController.text.trim(),
          headers: headers,
          params: params,
          body: bodyController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = [
      const DropdownMenuItem(value: 'One-time Request', child: Text('One-time Request')),
      ...collections.map((c) => DropdownMenuItem(value: c.title, child: Text(c.title))),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCollection,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onChanged: (value) => setState(() => selectedCollection = value!),
                    items: dropdownItems,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _showNewCollectionDialog,
                  icon: const Icon(Icons.add),
                  tooltip: 'Create new collection',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // (everything below this remains unchanged)
            _buildMethodAndUrlInput(),
            const SizedBox(height: 20),
            _buildTabs(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runRequest,
        tooltip: 'Send Request',
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget _buildMethodAndUrlInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<String>(
            value: selectedMethod,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            onChanged: (value) => setState(() => selectedMethod = value!),
            items: httpMethods
                .map((method) => DropdownMenuItem(
                      value: method,
                      child: Text(method, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: 'https://api.example.com/endpoint',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Headers'),
            Tab(text: 'Body'),
            Tab(text: 'Params'),
            Tab(text: 'Auth'),
          ],
        ),
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildKeyValueTab(headers, 'Header'),
              _buildBodyTab(),
              _buildKeyValueTab(params, 'Param'),
              const Center(child: Text('Authentication coming soon...')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyValueTab(List<Map<String, String>> list, String label) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        ElevatedButton(
          onPressed: () => _showKeyValueDialog(label, (k, v) => setState(() => list.add({k: v}))),
          child: Text('Add $label'),
        ),
        const SizedBox(height: 8),
        ...list.map((item) => Card(
              child: ListTile(
                title: Text(item.keys.first),
                subtitle: Text(item.values.first),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => list.remove(item)),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildBodyTab() {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton<String>(
              value: bodyType,
              onChanged: (val) => setState(() => bodyType = val!),
              items: const [
                DropdownMenuItem(value: 'Raw', child: Text('Raw')),
                DropdownMenuItem(value: 'Form Data', child: Text('Form Data')),
              ],
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: languageType,
              onChanged: bodyType == 'Raw' ? (val) => setState(() => languageType = val!) : null,
              items: const [
                DropdownMenuItem(value: 'JSON', child: Text('JSON')),
                DropdownMenuItem(value: 'text', child: Text('Text')),
                DropdownMenuItem(value: 'javascript', child: Text('JavaScript')),
                DropdownMenuItem(value: 'html', child: Text('HTML')),
                DropdownMenuItem(value: 'xml', child: Text('XML')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: bodyController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                hintText: '{\n  "key": "value"\n}',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
