import 'package:hive/hive.dart';
import 'request_model.dart';

part 'collection_model.g.dart';

@HiveType(typeId: 0)
class CollectionModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  HiveList<RequestModel> requests;

  CollectionModel({
    required this.title,
    required this.description,
    required this.requests,
  });
}
