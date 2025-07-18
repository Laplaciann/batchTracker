import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';

Future<void> saveFullCSV(List<List<String>> rows) async {
  final csvData = const ListToCsvConverter().convert(rows);
  final bytes = utf8.encode(csvData);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "batches.csv")
    ..click();
  html.Url.revokeObjectUrl(url);
}
