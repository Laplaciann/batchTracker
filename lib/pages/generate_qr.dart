import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../models/batch.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final _plantController = TextEditingController();
  final _productTypeController = TextEditingController();

  String? _qrData;
  String? _batchId;
  DateTime _currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentDateTime = DateTime.now();
        });
        _startClock();
      }
    });
  }

  Future<void> _generateBatchAndQR() async {
    final plantLocation = _plantController.text.trim();
    final productType = _productTypeController.text.trim();

    if (plantLocation.isEmpty || productType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    final now = DateTime.now();
    final datePart = DateFormat('yyyyMMdd').format(now);
    final timePart = DateFormat('HHmmss').format(now);
    final batchId = '$plantLocation-$productType-$datePart$timePart';

    // For non-Code Blue, use a placeholder string for QR content
    final encodedData = "BATCH:$batchId";

    final batch = Batch(
      batchId: batchId,
      plantLocation: plantLocation,
      productType: productType,
      dateTime: now,
      encodedData: encodedData,
      isCodeBlue: false,
    );

    final box = Hive.box<Batch>('batches');
    await box.add(batch);

    setState(() {
      _qrData = encodedData;
      _batchId = batchId;
      _plantController.clear();
      _productTypeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(_currentDateTime);
    final formattedTime = DateFormat('HH:mm:ss').format(_currentDateTime);

    return Scaffold(
      appBar: AppBar(title: const Text("Generate Batch QR")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Date: $formattedDate"),
            Text("Time: $formattedTime"),
            const SizedBox(height: 16),
            TextField(
              controller: _plantController,
              decoration: const InputDecoration(labelText: "Plant Location"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _productTypeController,
              decoration: const InputDecoration(labelText: "Product Type"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateBatchAndQR,
              child: const Text("Generate QR and Batch ID"),
            ),
            const SizedBox(height: 16),
            if (_batchId != null && _qrData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Batch ID: $_batchId", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  QrImageView(
                    data: _qrData!,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 10),
                  const Text("QR Content:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectableText(_qrData!, style: const TextStyle(color: Colors.blue)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
