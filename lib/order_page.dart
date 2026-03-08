import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/dashboard_provider.dart';
import '../services/api_service.dart';
import 'order_tracking.dart';
import 'transaction.dart';

class OrdersPageFinal extends StatefulWidget {
  const OrdersPageFinal({Key? key}) : super(key: key);

  @override
  State<OrdersPageFinal> createState() => _OrdersPageFinalState();
}

class _OrdersPageFinalState extends State<OrdersPageFinal> {
  String selectedFilter = 'All';
  String searchQuery = '';
  bool loading = true;

  List<Map<String, dynamic>> orders = [];
  Map<String, dynamic> orderStats = {};

  @override
  void initState() {
    super.initState();
    loadOrders();
    loadStats();
  }

  Future<void> loadOrders() async {
    setState(() => loading = true);
    try {
      final data = await ApiService.getOrders();
      setState(() {
        orders = data.map((e) => Map<String, dynamic>.from(e)).toList();
        loading = false;
      });
      if (mounted) {
        context.read<DashboardProvider>().updateOrderCount(orders.length);
      }
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> loadStats() async {
    try {
      final stats = await ApiService.getOrderStats();
      setState(() { orderStats = stats; });
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await ApiService.updateOrderStatus(orderId, newStatus);
      await loadOrders();
      await loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order status updated to $newStatus'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await ApiService.deleteOrder(orderId);
      await loadOrders();
      await loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order deleted successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting order: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _openTrackingPage(Map<String, dynamic> order) {
    double lat = 0.0;
    double lng = 0.0;

    if (order['location'] != null) {
      lat = (order['location']['lat'] ?? order['location']['latitude'] ?? 0.0).toDouble();
      lng = (order['location']['lng'] ?? order['location']['longitude'] ?? 0.0).toDouble();
    } else if (order['latitude'] != null && order['longitude'] != null) {
      lat = (order['latitude'] ?? 0.0).toDouble();
      lng = (order['longitude'] ?? 0.0).toDouble();
    } else {
      lat = 24.8607;
      lng = 67.0011;
    }

    final orderId = (order['orderId'] ?? order['id'] ?? 'N/A').toString();
    final customerName = (order['customer'] ?? '').toString();
    final customerPhone = (order['phone'] ?? '').toString();
    final customerAddress = (order['address'] ?? 'N/A').toString();
    final billAmount = (order['totalAmount'] ?? 0).toString();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddOrderPage2(
          orderId: orderId,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          billAmount: billAmount,
          orderLocation: LatLng(lat, lng),
        ),
      ),
    );
  }

  void _openTransactionPage(Map<String, dynamic> order) {
    final orderId = (order['orderId'] ?? order['id'] ?? 'N/A').toString();
    final customerName = (order['customer'] ?? '').toString();
    final totalAmount = (order['totalAmount'] ?? 0).toString();

    final List<Map<String, dynamic>> txns = [];
    if (order['transactions'] != null) {
      for (var t in (order['transactions'] as List)) {
        txns.add(Map<String, dynamic>.from(t));
      }
    } else {
      txns.add({
        'id': 'TXN-$orderId',
        'orderId': orderId,
        'customer': customerName,
        'date': (order['date']?.toString() ?? DateTime.now().toString()).split('T').first,
        'amount': order['totalAmount'] ?? 0,
        'status': order['paymentStatus'] ??
            (order['status'] == 'Delivered' ? 'Success' : order['status'] == 'Cancelled' ? 'Failed' : 'Pending'),
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionPage(
          orderId: orderId,
          customerName: customerName,
          orderAmount: totalAmount,
          orderTransactions: txns,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get filteredOrders {
    var filtered = orders.where((order) {
      final matchesFilter = selectedFilter == 'All' || order['status'] == selectedFilter;
      final matchesSearch =
          (order['orderId'] ?? order['id'] ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
              (order['customer'] ?? '').toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    filtered.sort((a, b) {
      DateTime dateA = a['date'] is String ? DateTime.parse(a['date']) : a['date'] as DateTime;
      DateTime dateB = b['date'] is String ? DateTime.parse(b['date']) : b['date'] as DateTime;
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  String _calculateOrderAge(dynamic orderDate) {
    DateTime date = orderDate is String ? DateTime.parse(orderDate) : orderDate as DateTime;
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} min ago';
    if (difference.inDays < 1) return '${difference.inHours} hrs ago';
    if (difference.inDays < 30) return '${difference.inDays} days ago';
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }

  String formatDate(dynamic date) {
    DateTime dateTime = date is String ? DateTime.parse(date) : date as DateTime;
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  String formatDateTime(dynamic date) {
    DateTime dateTime = date is String ? DateTime.parse(date) : date as DateTime;
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} - $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (loading && orders.isEmpty) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor ?? theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Text('Orders',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  width: 400,
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: theme.iconTheme.color?.withOpacity(0.6)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Search orders by ID or customer...',
                            hintStyle: TextStyle(color: theme.hintColor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: Icon(Icons.refresh, size: 28, color: theme.iconTheme.color),
                  onPressed: () { loadOrders(); loadStats(); },
                ),
              ],
            ),
          ),

          // ── Content ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('Total Orders', (orderStats['totalOrders'] ?? orders.length).toString(), Icons.shopping_bag, Colors.blue, theme)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildStatCard('Pending', (orderStats['pending'] ?? orders.where((o) => o['status'] == 'Pending').length).toString(), Icons.pending, Colors.orange, theme)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildStatCard('Processing', (orderStats['processing'] ?? orders.where((o) => o['status'] == 'Processing').length).toString(), Icons.autorenew, Colors.purple, theme)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildStatCard('Delivered', (orderStats['delivered'] ?? orders.where((o) => o['status'] == 'Delivered').length).toString(), Icons.check_circle, Colors.green, theme)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled']
                          .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildFilterChip(f, theme),
                      ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ── Table ────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ── Column Header Row ────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: _headerCell('Order / Customer', theme)),
                              Expanded(flex: 2, child: _headerCell('Items', theme)),
                              Expanded(flex: 2, child: _headerCell('Amount', theme)),
                              Expanded(flex: 2, child: _headerCell('Order Age', theme)),
                              // Status fixed width
                              SizedBox(width: 110, child: _headerCell('Status', theme)),
                              // Track slot fixed width (always reserved)
                              const SizedBox(width: 90),
                              // Three-dot slot
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: theme.dividerColor),

                        // ── Rows ─────────────────────────────────
                        filteredOrders.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 64,
                                    color: theme.iconTheme.color?.withOpacity(0.3)),
                                const SizedBox(height: 16),
                                Text('No orders found',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                                    )),
                              ],
                            ),
                          ),
                        )
                            : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredOrders.length,
                          separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor),
                          itemBuilder: (context, index) =>
                              _buildOrderRow(filteredOrders[index], theme),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String label, ThemeData theme) => Text(
    label,
    style: theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.textTheme.bodySmall?.color?.withOpacity(0.45),
      letterSpacing: 0.4,
    ),
  );

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text(title, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ThemeData theme) {
    final isSelected = selectedFilter == label;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => setState(() => selectedFilter = label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : theme.chipTheme.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: TextStyle(
                color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              )),
        ),
      ),
    );
  }

  Widget _buildOrderRow(Map<String, dynamic> order, ThemeData theme) {
    int totalItems = 0;
    final products = order['products'] ?? [];
    for (var product in products) {
      totalItems += (product['qty'] ?? 0) as int;
    }

    final orderAge = _calculateOrderAge(order['date']);
    final orderId = order['orderId'] ?? order['id'] ?? 'N/A';
    final status = order['status'] ?? 'Pending';
    final bool canTrack = status == 'Pending' || status == 'Processing' || status == 'Shipped';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => _showOrderDetails(order, theme),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Order / Customer — flex: 3
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderId,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(order['customer'] ?? 'Unknown',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        )),
                  ],
                ),
              ),

              // Items — flex: 2
              Expanded(
                flex: 2,
                child: Text('$totalItems items',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ),

              // Amount — flex: 2
              Expanded(
                flex: 2,
                child: Text('\$${(order['totalAmount'] ?? 0).toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.green,
                    )),
              ),

              // Order Age — flex: 2
              Expanded(
                flex: 2,
                child: Text(orderAge,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ),

              // Status badge — fixed 110
              SizedBox(
                width: 110,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),

              // Track slot — fixed 90 (always reserved so rows don't shift)
              SizedBox(
                width: 90,
                child: canTrack
                    ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Tooltip(
                    message: 'Track Order',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => _openTrackingPage(order),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6F00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFF6F00).withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.location_on, color: Color(0xFFFF6F00), size: 14),
                              SizedBox(width: 4),
                              Text('Track',
                                  style: TextStyle(
                                    color: Color(0xFFFF6F00),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              // Three-dot menu — fixed 40
              SizedBox(
                width: 40,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
                  color: theme.cardColor,
                  onSelected: (value) {
                    if (value == 'view') _showOrderDetails(order, theme);
                    else if (value == 'track') _openTrackingPage(order);
                    else if (value == 'payments') _openTransactionPage(order);
                    else if (value == 'status') _updateStatus(order, theme);
                    else if (value == 'delete') _confirmDelete(order, theme);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(children: [
                        Icon(Icons.visibility, size: 18, color: theme.iconTheme.color),
                        const SizedBox(width: 10),
                        Text('View Details', style: theme.textTheme.bodyMedium),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'payments',
                      child: Row(children: [
                        const Icon(Icons.receipt_long_rounded, size: 18, color: Colors.purple),
                        const SizedBox(width: 10),
                        Text('View Payments', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.purple)),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'track',
                      child: Row(children: [
                        const Icon(Icons.location_on, size: 18, color: Color(0xFFFF6F00)),
                        const SizedBox(width: 10),
                        Text('Track Order', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFFF6F00))),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'status',
                      child: Row(children: [
                        Icon(Icons.update, size: 18, color: theme.iconTheme.color),
                        const SizedBox(width: 10),
                        Text('Change Status', style: theme.textTheme.bodyMedium),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        const Icon(Icons.delete, size: 18, color: Colors.red),
                        const SizedBox(width: 10),
                        const Text('Delete Order', style: TextStyle(color: Colors.red)),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':  return Colors.green;
      case 'Processing': return Colors.blue;
      case 'Shipped':    return Colors.orange;
      case 'Pending':    return Colors.grey;
      case 'Cancelled':  return Colors.red;
      default:           return Colors.grey;
    }
  }

  void _showOrderDetails(Map<String, dynamic> order, ThemeData theme) {
    int totalItems = 0;
    final products = order['products'] ?? [];
    for (var product in products) {
      totalItems += (product['qty'] ?? 0) as int;
    }

    final orderAge = _calculateOrderAge(order['date']);
    final orderId = order['orderId'] ?? order['id'] ?? 'N/A';
    final status = order['status'] ?? 'Pending';
    final bool canTrack = status == 'Pending' || status == 'Processing' || status == 'Shipped';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Details',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.close, color: theme.iconTheme.color),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  _buildDetailRow('Order ID', orderId, theme),
                  _buildDetailRow('Customer', order['customer'] ?? 'Unknown', theme),
                  _buildDetailRow('Email', order['email'] ?? 'N/A', theme),
                  _buildDetailRow('Phone', order['phone'] ?? 'N/A', theme),
                  _buildDetailRow('Address', order['address'] ?? 'N/A', theme),
                  _buildDetailRow('Payment Method', order['paymentMethod'] ?? 'N/A', theme),
                  _buildDetailRow('Date', formatDateTime(order['date']), theme),
                  _buildDetailRow('Order Age', orderAge, theme),
                  _buildDetailRow('Total Items', '$totalItems items', theme),
                  const SizedBox(height: 20),
                  Text('Products', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...products.map<Widget>((product) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${product['name']} x${product['qty']}', style: theme.textTheme.bodyMedium),
                        Text('\$${((product['price'] ?? 0) * (product['qty'] ?? 0)).toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text('\$${(order['totalAmount'] ?? 0).toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.green,
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (canTrack) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () { Navigator.pop(context); _openTrackingPage(order); },
                            icon: const Icon(Icons.location_on),
                            label: const Text('Track Order'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6F00),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () { Navigator.pop(context); _updateStatus(order, theme); },
                          icon: const Icon(Icons.update),
                          label: const Text('Change Status'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () { Navigator.pop(context); _openTransactionPage(order); },
                          icon: const Icon(Icons.receipt_long_rounded),
                          label: const Text('Payments'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  void _updateStatus(Map<String, dynamic> order, ThemeData theme) {
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
    String selectedStatus = order['status'] ?? 'Pending';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          title: Text('Change Order Status', style: theme.textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ${order['orderId'] ?? order['id']}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 20),
              ...statuses.map((status) => RadioListTile<String>(
                title: Text(status, style: theme.textTheme.bodyMedium),
                value: status,
                groupValue: selectedStatus,
                activeColor: Colors.green,
                onChanged: (value) => setDialogState(() => selectedStatus = value!),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await updateOrderStatus(order['_id'] ?? order['id'], selectedStatus);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> order, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text('Delete Order', style: theme.textTheme.titleLarge),
        content: Text(
          'Are you sure you want to delete order ${order['orderId'] ?? order['id']}?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteOrder(order['_id'] ?? order['id']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}