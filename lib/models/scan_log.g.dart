// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanLogAdapter extends TypeAdapter<ScanLog> {
  @override
  final int typeId = 1;

  @override
  ScanLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanLog(
      timestamp: fields[0] as DateTime,
      ip: fields[1] as String,
      location: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ScanLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
