import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/batch.dart';
import '../utils/csv_utils.dart';

class BatchDatabasePage extends StatefulWidget {
  const BatchDatabasePage({super.key});

  @override
  State<BatchDatabasePage> createState() => _BatchDatabasePageState();
}

class _BatchDatabasePageState extends State<BatchDatabasePage> {
  late Box<Batch> batchBox;

  @override
  void initState() {
    super.initState();
    batchBox = Hive.box<Batch>('batches');
  }

  Future<void> _downloadCSV() async {
    final rows = <List<String>>[
      ['Batch ID', 'Plant Location', 'Product Type', 'Date', 'Time', 'Vehicle Number', 'Dispatch Location'],
    ];

    for (final batch in batchBox.values) {
      rows.add([
        batch.batchId,
        batch.plantLocation,
        batch.productType,
        DateFormat('yyyy-MM-dd').format(batch.dateTime),
        DateFormat('HH:mm:ss').format(batch.dateTime),
        batch.vehicleNumber ?? '',
        batch.dispatchLocation ?? '',
      ]);
    }

    await saveFullCSV(rows);
  }

  @override
  Widget build(BuildContext context) {
    final reversedBatches = batchBox.values.toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Batch Database")),
      body: reversedBatches.isEmpty
          ? const Center(child: Text("No batch data found."))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: reversedBatches.length,
              itemBuilder: (context, index) {
                final batch = reversedBatches[index];
                final vehicleController = TextEditingController(text: batch.vehicleNumber ?? '');
                final dispatchController = TextEditingController(text: batch.dispatchLocation ?? '');

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Batch ID: ${batch.batchId}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        QrImageView(
                          data: batch.isCodeBlue
                              ? 'https://batch-tracker-qdzq.onrender.com/scan/${batch.batchId}'
                              : batch.batchId,
                          version: QrVersions.auto,
                          size: 120,
                        ),
                        const SizedBox(height: 8),
                        Text("Plant Location: ${batch.plantLocation}"),
                        Text("Product Type: ${batch.productType}"),
                        Text("Date: ${DateFormat('yyyy-MM-dd').format(batch.dateTime)}"),
                        Text("Time: ${DateFormat('HH:mm:ss').format(batch.dateTime)}"),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vehicleController,
                          decoration: const InputDecoration(labelText: "Vehicle Number"),
                          readOnly: batch.isLocked,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: dispatchController,
                          decoration: const InputDecoration(labelText: "Dispatch Location"),
                          readOnly: batch.isLocked,
                        ),
                        const SizedBox(height: 8),
                        if (!batch.isLocked)
                          ElevatedButton(
                            onPressed: () async {
                              batch.vehicleNumber = vehicleController.text;
                              batch.dispatchLocation = dispatchController.text;
                              batch.isLocked = true;
                              await batch.save();
                              setState(() {});
                            },
                            child: const Text("Update"),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Download All as CSV"),
              onPressed: _downloadCSV,
            ),
          )
        ],
      ),
    );
  }
}
