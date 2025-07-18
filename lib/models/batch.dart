import 'package:hive/hive.dart';
import 'scan_log.dart';

part 'batch.g.dart'; // Make sure this is present for code generation

@HiveType(typeId: 0)
class Batch extends HiveObject {
  @HiveField(0)
  String batchId;

  @HiveField(1)
  String plantLocation;

  @HiveField(2)
  String productType;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String? vehicleNumber;

  @HiveField(5)
  String? dispatchLocation;

  @HiveField(6) // 👈 New field for Code Blue flag
  bool isCodeBlue;

  @HiveField(7)
  bool isLocked;

  @HiveField(9)
  List<ScanLog> scanLogs;

  @HiveField(10)
  String? encodedData;

  Batch({
    required this.batchId,
    required this.plantLocation,
    required this.productType,
    required this.dateTime,
    this.encodedData,
    this.vehicleNumber,
    this.dispatchLocation,
    this.isCodeBlue = false, // 👈 default to false
    this.isLocked = false,
    List<ScanLog>? scanLogs,
  }) : scanLogs = scanLogs ?? [];
}
