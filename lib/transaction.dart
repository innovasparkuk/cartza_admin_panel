import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // clipboard ke liye

class TransactionPage extends StatefulWidget {
  final String? orderId;
  final String? customerName;
  final String? orderAmount;
  final List<Map<String, dynamic>>? orderTransactions;

  const TransactionPage({
    super.key,
    this.orderId,
    this.customerName,
    this.orderAmount,
    this.orderTransactions,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _allTransactions = [
    {"id": "TXN123456789", "orderId": "ORD001", "customer": "Ali Hassan",   "date": "2025-12-24", "amount": 500.00,  "status": "Success"},
    {"id": "TXN123456793", "orderId": "ORD005", "customer": "Bilal Ahmed",  "date": "2025-12-22", "amount": 450.99,  "status": "Failed"},
    {"id": "TXN123456794", "orderId": "ORD001", "customer": "Ali Hassan",   "date": "2025-12-24", "amount": 50.00,   "status": "Success"},
  ];

  List<Map<String, dynamic>> get _base {
    if (widget.orderTransactions != null) return widget.orderTransactions!;
    if (widget.orderId != null)
      return _allTransactions.where((t) => t['orderId'] == widget.orderId).toList();
    return _allTransactions;
  }

  List<Map<String, dynamic>> get _transactions =>
      _filter == 'All' ? _base : _base.where((t) => t['status'] == _filter).toList();

  double get _totalAmount => _base.fold(0.0, (s, t) => s + (t['amount'] as num));
  int get _success => _base.where((t) => t['status'] == 'Success').length;
  int get _pending => _base.where((t) => t['status'] == 'Pending').length;
  int get _failed  => _base.where((t) => t['status'] == 'Failed').length;

  // ── Export: CSV text clipboard mein copy hoga ──────────────
  void _exportToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln('Transaction ID,Order ID,Customer,Date,Amount,Status');
    for (final t in _transactions) {
      buffer.writeln(
        '${t['id']},${t['orderId'] ?? ''},${t['customer'] ?? ''},${t['date']},${t['amount']},${t['status']}',
      );
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: const [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Text('CSV copied to clipboard!', style: TextStyle(fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Export: download dialog ─────────────────────────────────
  void _showExportDialog() {
    final buffer = StringBuffer();
    buffer.writeln('Transaction ID,Order ID,Customer,Date,Amount,Status');
    for (final t in _transactions) {
      buffer.writeln(
        '${t['id']},${t['orderId'] ?? ''},${t['customer'] ?? ''},${t['date']},${t['amount']},${t['status']}',
      );
    }
    final csvText = buffer.toString();

    showDialog(
      context: context,
      builder: (ctx) {
        // ── Dialog reads theme at build time so it always matches ──
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textP  = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF111111);
        final textS  = isDark ? const Color(0xFF888888) : const Color(0xFF777777);
        final previewBg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF4F4F6);

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Export Transactions', style: TextStyle(
                    color: textP, fontSize: 17, fontWeight: FontWeight.w800)),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Icon(Icons.close, color: textS, size: 20),
                ),
              ]),
              const SizedBox(height: 6),
              Text('${_transactions.length} records • CSV format',
                  style: TextStyle(color: textS, fontSize: 12)),
              const SizedBox(height: 20),
              // Preview box
              Container(
                height: 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: previewBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(csvText,
                      style: TextStyle(
                          color: textS, fontSize: 10,
                          fontFamily: 'monospace')),
                ),
              ),
              const SizedBox(height: 16),
              // Copy button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _exportToClipboard();
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy CSV to Clipboard',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Paste instructions
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.2)),
                ),
                child: Row(children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Color(0xFF22C55E), size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Paste in Excel / Google Sheets to open as spreadsheet.',
                    style: TextStyle(color: textS, fontSize: 11),
                  )),
                ]),
              ),
            ]),
          ),
        );
      },
   );
  }

  @override
  Widget build(BuildContext context) {

    // ── All theme-dependent colors derived from live brightness ──
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg     = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF4F4F6);
    final cardBg = isDark ? const Color(0xFF161616) : Colors.white;
    final surfBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F3);
    final border = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE2E2E8);
    final textP  = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF111111);
    final textS  = isDark ? const Color(0xFF888888) : const Color(0xFF777777);
    const orange = Color(0xFF22C55E); // changed to green
    const green  = Color(0xFF22C55E);
    const amber  = Color(0xFFF59E0B);
    const red    = Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: bg,
      body: Column(children: [
        // ── Header ──────────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 14, 20, 16),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border(bottom: BorderSide(color: border)),
            boxShadow: isDark ? [] : [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Back + Title + Export
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: surfBg, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: border),
                  ),
                  child: Icon(Icons.arrow_back_ios_new, color: textP, size: 15),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  widget.orderId != null ? 'Order #${widget.orderId}' : 'Payments & Transactions',
                  style: TextStyle(color: textP, fontSize: 17,
                      fontWeight: FontWeight.w800, letterSpacing: -0.3),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                if (widget.customerName?.isNotEmpty == true)
                  Text(widget.customerName!,
                      style: TextStyle(color: textS, fontSize: 12)),
              ])),
              // Export button — opens dialog
              GestureDetector(
                onTap: _showExportDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                        color: const Color(0xFF22C55E).withOpacity(0.35), blurRadius: 10,
                        offset: const Offset(0, 3))],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.download_rounded, color: Colors.white, size: 15),
                    SizedBox(width: 6),
                    Text('Export', style: TextStyle(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
            ]),

            const SizedBox(height: 18),

            // ── Summary tiles ──────────────────────────────────
            Row(children: [
              Expanded(child: _summaryTile(Icons.account_balance_wallet_rounded,
                  'Total', '\$${_totalAmount.toStringAsFixed(0)}',
                  orange, surfBg, textP, textS)),
              const SizedBox(width: 8),
              Expanded(child: _summaryTile(Icons.check_circle_rounded,
                  'Success', '$_success', green, surfBg, textP, textS)),
              const SizedBox(width: 8),
              Expanded(child: _summaryTile(Icons.hourglass_top_rounded,
                  'Pending', '$_pending', amber, surfBg, textP, textS)),
              const SizedBox(width: 8),
              Expanded(child: _summaryTile(Icons.cancel_rounded,
                  'Failed', '$_failed', red, surfBg, textP, textS)),
            ]),

            const SizedBox(height: 14),

            // ── Filter chips ───────────────────────────────────
            Row(children: ['All', 'Success', 'Pending', 'Failed'].map((f) =>
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _filter == f ? _chipColor(f) : surfBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _filter == f ? _chipColor(f) : border),
                      ),
                      child: Text(f, style: TextStyle(
                        color: _filter == f ? Colors.white : textS,
                        fontSize: 12,
                        fontWeight: _filter == f ? FontWeight.w700 : FontWeight.w500,
                      )),
                    ),
                  ),
                )).toList(),
            ),
          ]),
        ),

        // ── Transactions list ────────────────────────────────────
        Expanded(
          child: _transactions.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.receipt_long_outlined,
                size: 60, color: textS.withOpacity(0.35)),
            const SizedBox(height: 10),
            Text('No transactions found',
                style: TextStyle(color: textS, fontSize: 13)),
          ]))
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            itemCount: _transactions.length,
            itemBuilder: (_, i) => _txnCard(
                _transactions[i], cardBg, border, textP, textS, isDark),
          ),
        ),
      ]),
    );
  }

  Widget _summaryTile(IconData icon, String label, String value,
      Color color, Color surfBg, Color textP, Color textS) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(
            color: textP, fontSize: 16, fontWeight: FontWeight.w900, height: 1)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: textS, fontSize: 10)),
      ]),
    );
  }

  Widget _txnCard(Map<String, dynamic> t, Color cardBg, Color border,
      Color textP, Color textS, bool isDark) {
    final status = t['status'] as String;
    final sc = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.035), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        // Status icon
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: sc.withOpacity(0.12), shape: BoxShape.circle,
          ),
          child: Icon(_statusIcon(status), color: sc, size: 20),
        ),
        const SizedBox(width: 12),
        // ID + date + customer
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t['id'].toString(),
              style: TextStyle(color: textP, fontSize: 13,
                  fontWeight: FontWeight.w700, letterSpacing: 0.1)),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.calendar_today_rounded, size: 10, color: textS),
            const SizedBox(width: 3),
            Text(t['date'].toString(),
                style: TextStyle(color: textS, fontSize: 11)),
            if (t['customer'] != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.person_outline_rounded, size: 10, color: textS),
              const SizedBox(width: 3),
              Flexible(child: Text(t['customer'].toString(),
                  style: TextStyle(color: textS, fontSize: 11),
                  overflow: TextOverflow.ellipsis)),
            ],
          ]),
        ])),
        // Amount + badge
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\$${(t['amount'] as num).toStringAsFixed(2)}',
              style: TextStyle(
                color: status == 'Success' ? const Color(0xFF22C55E) : textP,
                fontSize: 16, fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: sc.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sc.withOpacity(0.3)),
            ),
            child: Text(status, style: TextStyle(
                color: sc, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ]),
      ]),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Success': return const Color(0xFF22C55E);
      case 'Pending': return const Color(0xFFF59E0B);
      case 'Failed':  return const Color(0xFFEF4444);
      default: return Colors.grey;
    }
  }
  IconData _statusIcon(String s) {
    switch (s) {
      case 'Success': return Icons.check_circle_rounded;
      case 'Pending': return Icons.hourglass_top_rounded;
      case 'Failed':  return Icons.cancel_rounded;
      default: return Icons.help_outline_rounded;
    }
  }
  Color _chipColor(String f) {
    switch (f) {
      case 'Success': return const Color(0xFF22C55E);
      case 'Pending': return const Color(0xFFF59E0B);
      case 'Failed':  return const Color(0xFFEF4444);
      default: return const Color(0xFF22C55E);
    }
  }
}
