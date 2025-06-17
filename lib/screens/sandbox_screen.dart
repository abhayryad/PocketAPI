import 'package:flutter/material.dart';
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

  final List<String> collectionOptions = [
    'One-time Request',
    'Collection 1',
    'Collection 2'
  ];
  String selectedCollection = 'One-time Request';

  final TextEditingController urlController = TextEditingController();
  final List<Map<String, String>> headers = [];
  final List<Map<String, String>> params = [];

  String bodyType = 'Raw';
  String languageType = 'JSON';
  final TextEditingController bodyController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

  void _runRequest() {
    if (urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResponseScreen(
          method: selectedMethod,
          url: urlController.text,
          headers: headers,
          params: params,
          body: bodyController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Sandbox'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Collection dropdown row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCollection,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedCollection = value);
                      }
                    },
                    items: collectionOptions
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  tooltip: 'Create new collection',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Method and URL row
            Row(
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
                              child: Text(
                                method,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
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
            ),
            const SizedBox(height: 20),

            // Tab bar and content
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false, // Important for equal distribution
                    labelPadding: EdgeInsets.zero, // Remove default padding
                    tabs: [
                      Tab(child: Container(width: double.infinity, child: const Text('Headers', textAlign: TextAlign.center))),
                      Tab(child: Container(width: double.infinity, child: const Text('Body', textAlign: TextAlign.center))),
                      Tab(child: Container(width: double.infinity, child: const Text('Params', textAlign: TextAlign.center))),
                      Tab(child: Container(width: double.infinity, child: const Text('Auth', textAlign: TextAlign.center))),
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Headers tab
                      ListView(
                        padding: const EdgeInsets.all(8),
                        children: [
                          ElevatedButton(
                            onPressed: () => _showKeyValueDialog(
                                'Header', (k, v) => setState(() => headers.add({k: v}))),
                            child: const Text('Add Header'),
                          ),
                          const SizedBox(height: 8),
                          ...headers.map((h) => Card(
                            child: ListTile(
                              title: Text(h.keys.first),
                              subtitle: Text(h.values.first),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => setState(() => headers.remove(h)),
                              ),
                            ),
                          )),
                        ],
                      ),

                      // Body tab
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: bodyType,
                                onChanged: (value) => setState(() => bodyType = value!),
                                items: const [
                                  DropdownMenuItem(value: 'Raw', child: Text('Raw')),
                                  DropdownMenuItem(value: 'Form Data', child: Text('Form Data')),
                                ],
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                value: languageType,
                                onChanged: bodyType == 'Raw'
                                    ? (value) => setState(() => languageType = value!)
                                    : null,
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
                      ),

                      // Params tab
                      ListView(
                        padding: const EdgeInsets.all(8),
                        children: [
                          ElevatedButton(
                            onPressed: () => _showKeyValueDialog(
                                'Param', (k, v) => setState(() => params.add({k: v}))),
                            child: const Text('Add Parameter'),
                          ),
                          const SizedBox(height: 8),
                          ...params.map((p) => Card(
                            child: ListTile(
                              title: Text(p.keys.first),
                              subtitle: Text(p.values.first),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => setState(() => params.remove(p)),
                              ),
                            ),
                          )),
                        ],
                      ),

                      // Auth tab
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Authentication options coming soon...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
}