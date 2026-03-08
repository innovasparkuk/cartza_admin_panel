import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  final List<Map<String, dynamic>> transactions = const [
    {"id": "TXN123456789", "date": "2025-12-24", "amount": 500.00,  "status": "Success"},
    {"id": "TXN123456790", "date": "2025-12-23", "amount": 120.50,  "status": "Pending"},
    {"id": "TXN123456791", "date": "2025-12-22", "amount": 45.99,   "status": "Failed"},
    {"id": "TXN123456792", "date": "2025-12-23", "amount": 127.50,  "status": "Pending"},
    {"id": "TXN123456793", "date": "2025-12-22", "amount": 450.99,  "status": "Failed"},
    {"id": "TXN123456794", "date": "2025-12-24", "amount": 50.00,   "status": "Success"},
  ];

  void exportTransactions(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln("Transaction ID,Date,Amount,Status");
    for (final t in transactions) {
      buffer.writeln("${t['id']},${t['date']},${t['amount']},${t['status']}");
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Text("CSV copied to clipboard!",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Theme-aware colors ──────────────────────────────────────
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg      = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF4F4F6);
    final cardBg  = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final border  = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE2E2E8);
    final textP   = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF111111);
    final textS   = isDark ? const Color(0xFF888888) : const Color(0xFF555555);
    const green   = Color(0xFF22C55E);
    const amber   = Color(0xFFF59E0B);
    const red     = Color(0xFFEF4444);

    return Scaffold(
      // ── backgroundColor hardcode nahi — theme se aayega ──────
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161616) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Payments & Transactions",
          style: TextStyle(
            color: Color(0xFF22C55E), // ── orange → green ──
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textP),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: border),
        ),
      ),
      body: Column(children: [
        // ── Export button ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => exportTransactions(context),
              icon: const Icon(Icons.file_download_outlined, size: 16, color: Colors.white),
              label: const Text("Export CSV",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: green, // ── orange → green ──
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                elevation: 0,
              ),
            ),
          ),
        ),

        // ── Transaction list ────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final item = transactions[index];
              final status = item['status'] as String;

              final statusColor = status == 'Success'
                  ? green
                  : status == 'Pending'
                  ? amber
                  : red;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: cardBg,           // ── dark mein dark, light mein white ──
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                  boxShadow: isDark
                      ? []
                      : [BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )],
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  title: Text(
                    item['id'],
                    style: TextStyle(
                        color: textP,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "${item['date']}  |  \$${item['amount']}",
                      style: TextStyle(color: textS, fontSize: 12),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}