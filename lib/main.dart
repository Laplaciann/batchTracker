import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/batch.dart';
import 'models/scan_log.dart';

import 'pages/generate_qr.dart';
import 'pages/batch_database.dart';
import 'pages/code_blue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(BatchAdapter());
  Hive.registerAdapter(ScanLogAdapter());

  // Open the Hive box to store batch data
  await Hive.openBox<Batch>('batches');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batch Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    const GenerateQRPage(),
    const BatchDatabasePage(),
    const CodeBluePage(),
    const MonitorPage(),
  ];

  final List<String> titles = [
    'Generate QR',
    'View Database',
    'Code Blue',
    'Monitor',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Generate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Database',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Code Blue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'Monitor',
          ),
        ],
      ),
    );
  }
}

// ---------------- Monitor Page ----------------

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  List<Map<String, dynamic>> scanLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScanLogs();
  }
  // https://batch-tracker-qdzq.onrender.com
  Future<void> fetchScanLogs() async {
    try {
      final response = await http.get(Uri.parse('https://batch-tracker-qdzq.onrender.com/scanlogs'));
      // print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> && decoded['logs'] is List) {
          final List<dynamic> logs = decoded['logs'];

          if (!mounted) return; // ✅ Prevent setState after dispose
          setState(() {
            scanLogs = logs.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
          });
        } else {
          // print('Unexpected data structure: $decoded');
        }
      } else {
        // print('Failed to load logs: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching logs: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monitor')),
      body: scanLogs.isEmpty
          ? Center(child: Text('No scan logs found'))
          : ListView.builder(
        itemCount: scanLogs.length,
        itemBuilder: (context, index) {
          final log = scanLogs[index];
          return ListTile(
            title: Text("Batch ID: ${log['BatchID']}"),
            subtitle: Text("IP: ${log['IPAddress']} | Location: ${log['Location']}"),
            trailing: Text(log['Timestamp']),
          );
        },
      ),
    );
  }
}
