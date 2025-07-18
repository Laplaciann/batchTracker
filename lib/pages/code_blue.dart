import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/batch.dart';

class CodeBluePage extends StatefulWidget {
  const CodeBluePage({super.key});

  @override
  State<CodeBluePage> createState() => _CodeBluePageState();
}

class _CodeBluePageState extends State<CodeBluePage> {
  late Box<Batch> batchBox;
  final Set<String> selectedBatches = {};

  @override
  void initState() {
    super.initState();
    batchBox = Hive.box<Batch>('batches');
  }

  void confirmCodeBlue(String batchId) async {
    final batch = batchBox.values.firstWhere((b) => b.batchId == batchId);

    // ✅ Update isCodeBlue flag
    batch.isCodeBlue = true;
    await batch.save();

    // ✅ Update the QR encoded data to the tracking URL
    batch.encodedData = 'https://batch-tracker-qdzq.onrender.com/scan/${batch.batchId}';

    // ✅ Save updated batch to Hive
    await batch.save();

    setState(() {
      selectedBatches.remove(batchId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Batch marked as Code Blue and QR updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final batches = batchBox.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Recent first

    return Scaffold(
      appBar: AppBar(title: const Text('Code Blue')),
      body: ListView.builder(
        itemCount: batches.length,
        itemBuilder: (context, index) {
          final batch = batches[index];
          final isSelected = selectedBatches.contains(batch.batchId);

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Batch ID: ${batch.batchId}'),
              subtitle: batch.isCodeBlue
                  ? const Text('🚨 Code Blue Confirmed', style: TextStyle(color: Colors.red))
                  : const Text('Not flagged'),
              trailing: batch.isCodeBlue
                  ? null
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedBatches.add(batch.batchId);
                        } else {
                          selectedBatches.remove(batch.batchId);
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: isSelected ? () => confirmCodeBlue(batch.batchId) : null,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
