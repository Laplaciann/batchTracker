import 'package:uuid/uuid.dart';

String generateBatchId({
  required String date,
  required String time,
  required String location,
  required String product,
}) {
  const uuid = Uuid();
  String suffix = uuid.v4().substring(0, 6); // Short unique part
  return "${date.replaceAll('-', '')}_${time.replaceAll(':', '')}_${location}_${product}_$suffix";
}
