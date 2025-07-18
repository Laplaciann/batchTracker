// lib/models/scan_log.dart
import 'package:hive/hive.dart';

part 'scan_log.g.dart';

@HiveType(typeId: 1)
class ScanLog extends HiveObject {
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  String ip;

  @HiveField(2)
  String location;

  ScanLog({
    required this.timestamp,
    required this.ip,
    required this.location,
  });
}
