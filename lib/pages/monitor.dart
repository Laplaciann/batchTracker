import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MonitorPage extends StatefulWidget {
  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  List<Map<String, dynamic>> scanLogs = [];
  bool _isLoading = false;
  Timer? _timer;
  DateTime? _lastRefreshed;

  @override
  void initState() {
    super.initState();
    fetchScanLogs();
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      fetchScanLogs();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchScanLogs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://batch-logger.onrender.com/scanlogs'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final logs = data['logs'];

        if (mounted) {
          setState(() {
            scanLogs = List<Map<String, dynamic>>.from(logs);
            _lastRefreshed = DateTime.now();
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch scan logs');
      }
    } catch (e) {
      // print('Error fetching logs: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String get formattedRefreshTime {
    if (_lastRefreshed == null) return '';
    return DateFormat('hh:mm:ss a').format(_lastRefreshed!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchScanLogs,
            tooltip: 'Refresh now',
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_lastRefreshed != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Last refreshed at: $formattedRefreshTime',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : scanLogs.isEmpty
                ? Center(child: Text('No scan logs found'))
                : RefreshIndicator(
              onRefresh: fetchScanLogs,
              child: ListView.builder(
                itemCount: scanLogs.length,
                itemBuilder: (context, index) {
                  final log = scanLogs[index];
                  return ListTile(
                    title: Text("Batch ID: ${log['BatchID']}"),
                    subtitle: Text(
                        "IP: ${log['IPAddress']}\nLocation: ${log['Location']}"),
                    trailing: Text(log['Timestamp']),
                    isThreeLine: true,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
