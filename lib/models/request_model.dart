import 'package:hive/hive.dart';

part 'request_model.g.dart';

@HiveType(typeId: 1)
class RequestModel extends HiveObject {
  @HiveField(0)
  String method;

  @HiveField(1)
  String url;

  @HiveField(2)
  List<Map<String, String>> headers;

  @HiveField(3)
  List<Map<String, String>> params;

  @HiveField(4)
  String body;

  @HiveField(5)
  DateTime timestamp;

  RequestModel({
    required this.method,
    required this.url,
    required this.headers,
    required this.params,
    required this.body,
    required this.timestamp,
  });
}
