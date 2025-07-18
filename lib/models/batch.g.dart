// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BatchAdapter extends TypeAdapter<Batch> {
  @override
  final int typeId = 0;

  @override
  Batch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Batch(
      batchId: fields[0] as String,
      plantLocation: fields[1] as String,
      productType: fields[2] as String,
      dateTime: fields[3] as DateTime,
      encodedData: fields[10] as String?,
      vehicleNumber: fields[4] as String?,
      dispatchLocation: fields[5] as String?,
      isCodeBlue: fields[6] as bool,
      isLocked: fields[7] as bool,
      scanLogs: (fields[9] as List?)?.cast<ScanLog>(),
    );
  }

  @override
  void write(BinaryWriter writer, Batch obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.batchId)
      ..writeByte(1)
      ..write(obj.plantLocation)
      ..writeByte(2)
      ..write(obj.productType)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.vehicleNumber)
      ..writeByte(5)
      ..write(obj.dispatchLocation)
      ..writeByte(6)
      ..write(obj.isCodeBlue)
      ..writeByte(7)
      ..write(obj.isLocked)
      ..writeByte(9)
      ..write(obj.scanLogs)
      ..writeByte(10)
      ..write(obj.encodedData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
