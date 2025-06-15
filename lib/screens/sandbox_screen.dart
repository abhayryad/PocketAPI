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
            child: const Text('Back'),
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
        actions: [
          TextButton(
            onPressed: _runRequest,
            child: const Text('Run', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedMethod,
                  onChanged: (value) => setState(() => selectedMethod = value!),
                  items: httpMethods
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      hintText: 'https://api.example.com/endpoint',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _showKeyValueDialog('Header',
                            (k, v) => setState(() => headers.add({k: v}))),
                        child: const Text('Add Header'),
                      ),
                      ...headers.map((h) => ListTile(
                            title: Text(h.keys.first),
                            subtitle: Text(h.values.first),
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: bodyType,
                            onChanged: (value) =>
                                setState(() => bodyType = value!),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Raw', child: Text('Raw')),
                              DropdownMenuItem(
                                  value: 'Form Data', child: Text('Form Data')),
                            ],
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: languageType,
                            onChanged: (value) =>
                                setState(() => languageType = value!),
                            items: const [
                              DropdownMenuItem(
                                  value: 'JSON', child: Text('JSON')),
                              DropdownMenuItem(
                                  value: 'text', child: Text('Text')),
                              DropdownMenuItem(
                                  value: 'javascript',
                                  child: Text('JavaScript')),
                              DropdownMenuItem(
                                  value: 'html', child: Text('HTML')),
                              DropdownMenuItem(
                                  value: 'xml', child: Text('XML')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TextField(
                          controller: bodyController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '{ "key": "value" }',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _showKeyValueDialog('Param',
                            (k, v) => setState(() => params.add({k: v}))),
                        child: const Text('New Parameter'),
                      ),
                      ...params.map((p) => ListTile(
                            title: Text(p.keys.first),
                            subtitle: Text(p.values.first),
                          )),
                    ],
                  ),
                  const Center(child: Text('Auth coming soon...')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
