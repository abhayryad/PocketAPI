import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponseScreen extends StatefulWidget {
  final String method;
  final String url;
  final List<Map<String, String>> headers;
  final List<Map<String, String>> params;
  final String body;

  const ResponseScreen({
    super.key,
    required this.method,
    required this.url,
    required this.headers,
    required this.params,
    required this.body,
  });

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  String _response = 'Sending request...';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _sendRequest();
  }

  Future<void> _sendRequest() async {
    try {
      final uri = Uri.parse(widget.url).replace(
        queryParameters: {
          for (var param in widget.params)
            ...param, // merge all key-value maps
        },
      );

      final headers = {
        for (var h in widget.headers) ...h,
        'Content-Type': 'application/json',
      };

      late http.Response res;
      switch (widget.method.toUpperCase()) {
        case 'POST':
          res = await http.post(uri, headers: headers, body: widget.body);
          break;
        case 'PUT':
          res = await http.put(uri, headers: headers, body: widget.body);
          break;
        case 'PATCH':
          res = await http.patch(uri, headers: headers, body: widget.body);
          break;
        case 'DELETE':
          res = await http.delete(uri, headers: headers);
          break;
        case 'HEAD':
          res = await http.head(uri, headers: headers);
          break;
        case 'OPTIONS':
          res = await http.Request('OPTIONS', uri)
              .send()
              .then((r) => http.Response('', r.statusCode));
          break;
        case 'GET':
        default:
          res = await http.get(uri, headers: headers);
          break;
      }

      setState(() {
        _response = 'Status: ${res.statusCode}\n\n${res.body}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Response')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(_response),
            ),
    );
  }
}