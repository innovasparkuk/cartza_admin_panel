import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});

  final List<Map<String, dynamic>> transactions = [
    {"id": "TXN123456789", "date": "2025-12-24", "amount": 500.00, "status": "Success"},
    {"id": "TXN123456790", "date": "2025-12-23", "amount": 120.50, "status": "Pending"},
    {"id": "TXN123456791", "date": "2025-12-22", "amount": 45.99, "status": "Failed"},
    {"id": "TXN123456792", "date": "2025-12-23", "amount": 127.50, "status": "Pending"},
    {"id": "TXN123456793", "date": "2025-12-22", "amount": 450.99, "status": "Failed"},
    {"id": "TXN123456794", "date": "2025-12-24", "amount": 50.00, "status": "Success"},
  ];

  double getTotal(String status) {
    return transactions
        .where((t) => t['status'] == status)
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  int getCount(String status) {
    return transactions.where((t) => t['status'] == status).length;
  }

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
        SnackBar(content: Text("Export failed: $error")),
      );
    }
  }

  Widget summaryCard(String title, double amount, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("\$${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final successCount = getCount("Success");
    final pendingCount = getCount("Pending");
    final failedCount = getCount("Failed");
    final totalCount = transactions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Payments & Transactions",
          style: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => exportTransactions(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F00),
              ),
              child: const Text("Export CSV", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          /// LEFT SIDE
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      summaryCard("Successful", getTotal("Success"), Colors.green),
                      summaryCard("Pending", getTotal("Pending"), Colors.orange),
                      summaryCard("Failed", getTotal("Failed"), Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final item = transactions[index];
                        Color statusColor = item['status'] == "Success"
                            ? Colors.green
                            : item['status'] == "Pending"
                            ? Colors.orange
                            : Colors.red;

                        return Card(
                          color: Colors.white, // Card color changed to white
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              item['id'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // Transaction ID bold
                              ),
                            ),
                            subtitle: Text("${item['date']}  |  \$${item['amount']}"),
                            trailing: Text(
                              item['status'],
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// RIGHT SIDE – ANALYSIS
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Transaction Analysis",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  /// DONUT CHART (100%)
                  TransactionDonutChart(
                    success: successCount,
                    pending: pendingCount,
                    failed: failedCount,
                  ),

                  const SizedBox(height: 20),
                  Text("Total Transactions: $totalCount"),

                  const SizedBox(height: 20),
                  _legend("Success", Colors.green),
                  _legend("Pending", Colors.orange),
                  _legend("Failed", Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

/// ------------------ DONUT CHART ------------------

class TransactionDonutChart extends StatelessWidget {
  final int success;
  final int pending;
  final int failed;

  const TransactionDonutChart({
    super.key,
    required this.success,
    required this.pending,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 160),
      painter: _TransactionDonutPainter(
        success: success,
        pending: pending,
        failed: failed,
      ),
    );
  }
}

class _TransactionDonutPainter extends CustomPainter {
  final int success;
  final int pending;
  final int failed;

  _TransactionDonutPainter({
    required this.success,
    required this.pending,
    required this.failed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = success + pending + failed;
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    double startAngle = -1.5708;

    final successAngle = (success / total) * 6.28318;
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      successAngle,
      false,
      paint,
    );
    startAngle += successAngle;

    final pendingAngle = (pending / total) * 6.28318;
    paint.color = Colors.orange;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      pendingAngle,
      false,
      paint,
    );
    startAngle += pendingAngle;

    final failedAngle = (failed / total) * 6.28318;
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      failedAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
