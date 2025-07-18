// import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:universal_io/io.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFullCSV(List<List<String>> rows) async {
  final csvData = const ListToCsvConverter().convert(rows);
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/batches.csv');
  await file.writeAsString(csvData);
}
