// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestModelAdapter extends TypeAdapter<RequestModel> {
  @override
  final int typeId = 1;

  @override
  RequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestModel(
      method: fields[0] as String,
      url: fields[1] as String,
      headers: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      params: (fields[3] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      body: fields[4] as String,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RequestModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.method)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.headers)
      ..writeByte(3)
      ..write(obj.params)
      ..writeByte(4)
      ..write(obj.body)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
