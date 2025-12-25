import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TransactionPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {"id": "TXN123456789", "date": "2025-12-24", "amount": 500.00, "status": "Success"},
    {"id": "TXN123456790", "date": "2025-12-23", "amount": 120.50, "status": "Pending"},
    {"id": "TXN123456791", "date": "2025-12-22", "amount": 45.99, "status": "Failed"},
    {"id": "TXN123456792", "date": "2025-12-23", "amount": 127.50, "status": "Pending"},
    {"id": "TXN123456793", "date": "2025-12-22", "amount": 450.99, "status": "Failed"},
    {"id": "TXN123456789", "date": "2025-12-24", "amount": 50.00, "status": "Success"},
  ];

  // Export transactions as CSV
  void exportTransactions(BuildContext context) async {
    try {
      List<List<String>> rows = [
        ["Transaction ID", "Date", "Amount", "Status"],
      ];

      for (var t in transactions) {
        rows.add([
          t['id'].toString(),
          t['date'].toString(),
          t['amount'].toString(),
          t['status'].toString(),
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/transactions.csv";

      final file = File(filePath);
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(filePath)], text: "Transactions Report");
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Export failed : $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payments & Transactions",
          style: TextStyle(
            color: Color(0xFFFF6F00),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => exportTransactions(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6F00),
                ),
                child: Text(
                  "Export",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final item = transactions[index];

                Color statusColor;
                if (item['status'] == "Success") {
                  statusColor = Color(0xFF4CAF50);
                } else if (item['status'] == "Pending") {
                  statusColor = Colors.grey;
                } else {
                  statusColor = Colors.red;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item['id']),
                    subtitle: Text(
                      "${item['date']}  |  \$${item['amount']}",
                    ),
                    trailing: Text(
                      item['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
