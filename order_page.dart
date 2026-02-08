import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  String selectedFilter = 'All';
  String searchQuery = '';
  String selectedMenu = 'Orders';
  late AnimationController _taglineController;

  final List<Map<String, dynamic>> orders = [
    {
      'id': '#ORD-2024-001',
      'customer': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '+92 300 1234567',
      'products': [
        {'name': 'Wireless Headphones', 'qty': 1, 'price': 129.99}
      ],
      'totalAmount': 129.99,
      'status': 'Delivered',
      'date': DateTime(2024, 12, 5, 10, 30),
      'address': '123 Main St, Rawalpindi, Punjab',
      'paymentMethod': 'Credit Card',
    },
    {
      'id': '#ORD-2024-002',
      'customer': 'Sarah Smith',
      'email': 'sarah.smith@email.com',
      'phone': '+92 301 2345678',
      'products': [
        {'name': 'Smart Watch', 'qty': 1, 'price': 299.99}
      ],
      'totalAmount': 299.99,
      'status': 'Processing',
      'date': DateTime(2024, 12, 5, 14, 15),
      'address': '456 Park Ave, Islamabad',
      'paymentMethod': 'Cash on Delivery',
    },
    {
      'id': '#ORD-2024-003',
      'customer': 'Mike Johnson',
      'email': 'mike.j@email.com',
      'phone': '+92 302 3456789',
      'products': [
        {'name': 'Laptop Stand', 'qty': 2, 'price': 49.99}
      ],
      'totalAmount': 99.98,
      'status': 'Shipped',
      'date': DateTime(2024, 12, 4, 9, 45),
      'address': '789 Oak Rd, Lahore, Punjab',
      'paymentMethod': 'Debit Card',
    },
    {
      'id': '#ORD-2024-004',
      'customer': 'Emily Brown',
      'email': 'emily.brown@email.com',
      'phone': '+92 303 4567890',
      'products': [
        {'name': 'USB-C Cable', 'qty': 3, 'price': 19.99}
      ],
      'totalAmount': 59.97,
      'status': 'Delivered',
      'date': DateTime(2024, 12, 4, 16, 20),
      'address': '321 Pine St, Karachi',
      'paymentMethod': 'Credit Card',
    },
    {
      'id': '#ORD-2024-005',
      'customer': 'David Wilson',
      'email': 'david.w@email.com',
      'phone': '+92 304 5678901',
      'products': [
        {'name': 'Phone Case', 'qty': 1, 'price': 24.99}
      ],
      'totalAmount': 24.99,
      'status': 'Pending',
      'date': DateTime(2024, 12, 3, 11, 10),
      'address': '654 Elm St, Faisalabad, Punjab',
      'paymentMethod': 'Cash on Delivery',
    },
    {
      'id': '#ORD-2024-006',
      'customer': 'Lisa Anderson',
      'email': 'lisa.a@email.com',
      'phone': '+92 305 6789012',
      'products': [
        {'name': 'Bluetooth Speaker', 'qty': 1, 'price': 79.99}
      ],
      'totalAmount': 79.99,
      'status': 'Cancelled',
      'date': DateTime(2024, 12, 2, 13, 30),
      'address': '987 Maple Ave, Multan, Punjab',
      'paymentMethod': 'Credit Card',
    },
  ];

  @override
  void initState() {
    super.initState();
    _taglineController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _taglineController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredOrders {
    var filtered = orders.where((order) {
      final matchesFilter = selectedFilter == 'All' ||
          order['status'] == selectedFilter;
      final matchesSearch = order['id'].toLowerCase().contains(
          searchQuery.toLowerCase()) ||
          order['customer'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    filtered.sort((a, b) =>
        (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return filtered;
  }

  String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String formatDateTime(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date
        .hour);
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date
        .year} - $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.8, end: 1.0),
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logo1.png',
                                  width: 110,
                                  height: 75,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: AnimatedOpacity(
                            opacity: _taglineController.value,
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              'Shop Smarter, Live Better',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.green),
                  _buildMenuCard(Icons.dashboard, 'Dashboard', () =>
                      Navigator.pop(context)),
                  _buildMenuCard(Icons.shopping_bag, 'Orders', () {}),
                  _buildMenuCard(Icons.inventory, 'Products', () {}),
                  _buildMenuCard(Icons.category, 'Categories', () {}),
                  _buildMenuCard(Icons.people, 'Customers', () {}),
                  _buildMenuCard(Icons.payment, 'Payments', () {}),
                  _buildMenuCard(Icons.local_offer, 'Promotions', () {}),
                  _buildMenuCard(Icons.star, 'Reviews', () {}),
                  _buildMenuCard(Icons.analytics, 'Analytics', () {}),
                  _buildMenuCard(Icons.settings, 'Settings', () {}),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Orders',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 700,
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),

                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 30),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Search orders by Id...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 15),
                      IconButton(
                        icon: const Icon(
                            Icons.notifications_outlined, size: 28),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      const CircleAvatar(
                        backgroundColor: Colors.green, // changed from orange
                        child: Text('A', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),

                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(child: _buildStatCard(
                                'Total Orders', orders.length.toString(),
                                Icons.shopping_bag, Colors.blue)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildStatCard('Pending', orders
                                .where((o) => o['status'] == 'Pending')
                                .length
                                .toString(), Icons.pending, Colors.orange)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildStatCard('Processing', orders
                                .where((o) => o['status'] == 'Processing')
                                .length
                                .toString(), Icons.autorenew, Colors.purple)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildStatCard('Delivered', orders
                                .where((o) => o['status'] == 'Delivered')
                                .length
                                .toString(), Icons.check_circle, Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 25),
// Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('All'),
                              const SizedBox(width: 18),
                              _buildFilterChip('Pending'),
                              const SizedBox(width: 18),
                              _buildFilterChip('Processing'),
                              const SizedBox(width: 18),
                              _buildFilterChip('Shipped'),
                              const SizedBox(width: 18),
                              _buildFilterChip('Delivered'),
                              const SizedBox(width: 18),
                              _buildFilterChip('Cancelled'),
                              const SizedBox(width: 244),

                              // New Order Button
                              ElevatedButton.icon(
                                onPressed: _addNewOrder,
                                icon: const Icon(Icons.add, size: 20),
                                label: const Text('New Order'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Orders List
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: filteredOrders.length,
                            separatorBuilder: (context, index) =>
                            const Divider(height: 30),
                            itemBuilder: (context, index) {
                              return _buildOrderCard(filteredOrders[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, VoidCallback onTap) {
    final bool isSelected = selectedMenu == title;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.green.withOpacity(0.6),
              blurRadius: 14,
              spreadRadius: 3,
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    int totalItems = 0;
    for (var product in order['products']) {
      totalItems += product['qty'] as int;
    }

    return InkWell(
      onTap: () => _showOrderDetails(order),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['id'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    order['customer'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$totalItems items',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '\$${order['totalAmount'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    formatDate(order['date']),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(order['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order['status'],
                style: TextStyle(
                  color: _getStatusColor(order['status']),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'view') {
                  _showOrderDetails(order);
                } else if (value == 'invoice') {
                  _showInvoice(order);
                } else if (value == 'status') {
                  _updateStatus(order);
                } else if (value == 'delete') {
                  _deleteOrder(order);
                }
              },
              itemBuilder: (context) =>
              [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18),
                      SizedBox(width: 10),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'status',
                  child: Row(
                    children: [
                      Icon(Icons.update, size: 18),
                      SizedBox(width: 10),
                      Text('Change Status'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'invoice',
                  child: Row(
                    children: [
                      Icon(Icons.receipt, size: 18),
                      SizedBox(width: 10),
                      Text('View Invoice'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.green),
                      SizedBox(width: 10),
                      Text('Delete Order', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.orange;
      case 'Pending':
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    int totalItems = 0;
    for (var product in order['products']) {
      totalItems += product['qty'] as int;
    }

    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 10,
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    _buildDetailRow('Order ID', order['id']),
                    _buildDetailRow('Customer', order['customer']),
                    _buildDetailRow('Email', order['email']),
                    _buildDetailRow('Phone', order['phone']),
                    _buildDetailRow('Address', order['address']),
                    _buildDetailRow('Payment Method', order['paymentMethod']),
                    _buildDetailRow('Date', formatDateTime(order['date'])),
                    _buildDetailRow('Total Items', '$totalItems items'),
                    const SizedBox(height: 20),
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...order['products'].map<Widget>((product) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${product['name']} x${product['qty']}'),
                              Text(
                                '\$${(product['price'] * product['qty'])
                                    .toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${order['totalAmount'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _updateStatus(order);
                            },
                            icon: const Icon(Icons.update),
                            label: const Text('Change Status'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showInvoice(order);
                            },
                            icon: const Icon(Icons.receipt),
                            label: const Text('View Invoice'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(Map<String, dynamic> order) {
    final statuses = [
      'Pending',
      'Processing',
      'Shipped',
      'Delivered',
      'Cancelled'
    ];
    String selectedStatus = order['status'];

    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setDialogState) =>
                AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: const Text('Change Order Status'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Order ${order['id']}'),
                      const SizedBox(height: 20),
                      ...statuses.map((status) =>
                          RadioListTile<String>(
                            title: Text(status),
                            value: status,
                            groupValue: selectedStatus,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedStatus = value!;
                              });
                            },
                          )),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          order['status'] = selectedStatus;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Order status changed to $selectedStatus'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _deleteOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            title: const Text('Delete Order'),
            content: Text(
                'Are you sure you want to delete order ${order['id']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    orders.remove(order);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showInvoice(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'INVOICE',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              order['id'],
                              style:  TextStyle(fontSize: 16, color: Colors
                                  .white),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bill To:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order['customer'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(order['email'], style: const TextStyle(
                                  fontSize: 13)),
                              Text(order['phone'], style: const TextStyle(
                                  fontSize: 13)),
                              Text(order['address'], style: const TextStyle(
                                  fontSize: 13)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Invoice Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Date: ${formatDate(order['date'])}'),
                            Text('Status: ${order['status']}'),
                            Text('Payment: ${order['paymentMethod']}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'PRODUCT',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'QTY',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'PRICE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'TOTAL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...order['products'].map<Widget>((product) =>
                              Container(
                                padding:  EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(product['name']),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${product['qty']}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "\$${product['price'].toStringAsFixed(
                                            2)}",
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "\$${(product['price'] * product['qty'])
                                            .toStringAsFixed(2)}",
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),

                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text('Subtotal: ',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 20),
                                Text(
                                  "\$${order['totalAmount'].toStringAsFixed(
                                      2)}",
                                  style: const TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],

                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Text('Tax (0%): ',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(width: 20),
                                Text(
                                  '\$0.00',
                                  style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Text(
                                  'TOTAL: ',
                                  style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "\$${order['totalAmount'].toStringAsFixed(
                                      2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invoice printed successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(Icons.print),
                            label: const Text('Print Invoice'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invoice downloaded'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Download PDF'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
    );
  }

  void _addNewOrder() {
    // Create new order object
    final newOrder = {
      'id': '#ORD-2024-${(orders.length + 1).toString().padLeft(3, '0')}',
      'customer': 'New Customer',
      'email': 'customer@email.com',
      'phone': '+92 300 0000000',
      'products': [
        {'name': 'New Product', 'qty': 1, 'price': 99.99}
      ],
      'totalAmount': 99.99,
      'status': 'Pending',
      'date': DateTime.now(),
      'address': 'Address',
      'paymentMethod': 'Cash on Delivery',
    };

    // Add to list
    setState(() {
      orders.insert(0, newOrder);
    });

    // Show the order modal for editing
    _showOrderDialog(newOrder);
  }

  void _showOrderDialog(Map<String, dynamic> order) {
    final TextEditingController customerController =
    TextEditingController(text: order['customer']);
    final TextEditingController statusController =
    TextEditingController(text: order['status']);
    final TextEditingController amountController =
    TextEditingController(text: order['totalAmount'].toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // set max width for smaller dialog
              minWidth: 300, // optional: set min width
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Order',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Order ID (read-only)
                  Row(
                    children: [
                      const Text('Order ID: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Flexible(child: Text(order['id'])),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Customer Name
                  TextField(
                    controller: customerController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status
                  TextField(
                    controller: statusController,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Total Amount
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Update order values
                        setState(() {
                          order['customer'] = customerController.text;
                          order['status'] = statusController.text;
                          order['totalAmount'] = double.tryParse(
                              amountController.text) ??
                              order['totalAmount'];
                        });

                        Navigator.of(context).pop(); // Close dialog

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order updated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Update Order',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      },
    );
  }
}
// -------------------- Web Footer --------------------
Widget buildWebFooter() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1a1a1a),
          Color(0xFF0d0d0d),
        ],
      ),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  return _buildMobileFooterContent();
                } else {
                  return _buildDesktopFooterContent();
                }
              },
            ),
          ),

          // Divider with gradient
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFF4CAF50).withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Bottom Copyright Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 15,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copyright, color: Colors.white38, size: 14),
                    SizedBox(width: 5),
                    Text(
                      "2025 Cartza. All rights reserved.",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "We Accept:",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    _buildPaymentIcon(Icons.credit_card),
                    _buildPaymentIcon(Icons.account_balance_wallet),
                    _buildPaymentIcon(Icons.payment),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDesktopFooterContent() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Company Section with Logo
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "CARTZA",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Your trusted online shopping destination for quality products at the best prices.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Follow Us",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildSocialIcon(Icons.facebook, Color(0xFF1877F2)),
                SizedBox(width: 12),
                _buildSocialIcon(Icons.chat, Color(0xFF25D366)),
                SizedBox(width: 12),
                _buildSocialIcon(Icons.camera_alt, Color(0xFFE4405F)),
                SizedBox(width: 12),
                _buildSocialIcon(Icons.play_arrow, Color(0xFFFF0000)),
              ],
            ),
          ],
        ),
      ),
      SizedBox(width: 40),

      // Quick Links
      Expanded(
        child: _buildFooterColumn(
          "Shop",
          [
            "New Arrivals",
            "Best Sellers",
            "Flash Sale",
            "Categories",
            "Deals of the Day",
          ],
        ),
      ),

      // Customer Service
      Expanded(
        child: _buildFooterColumn(
          "Customer Care",
          [
            "Contact Us",
            "Help Center",
            "Track Order",
            "Returns & Refunds",
            "Shipping Info",
          ],
        ),
      ),

      // About & Legal
      Expanded(
        child: _buildFooterColumn(
          "Company",
          [
            "About Us",
            "Careers",
            "Privacy Policy",
            "Terms of Service",
            "Cookie Policy",
          ],
        ),
      ),

      // Newsletter Section
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Newsletter",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Subscribe to get special offers and updates",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.security, color: Color(0xFF4CAF50), size: 16),
                SizedBox(width: 8),
                Text(
                  "Secure Shopping",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildMobileFooterContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "CARTZA",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
      SizedBox(height: 12),
      Text(
        "Your trusted online shopping destination.",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          height: 1.4,
        ),
      ),
      SizedBox(height: 15),
      Row(
        children: [
          _buildSocialIcon(Icons.facebook, Color(0xFF1877F2)),
          SizedBox(width: 10),
          _buildSocialIcon(Icons.chat, Color(0xFF25D366)),
          SizedBox(width: 10),
          _buildSocialIcon(Icons.camera_alt, Color(0xFFE4405F)),
          SizedBox(width: 10),
          _buildSocialIcon(Icons.play_arrow, Color(0xFFFF0000)),
        ],
      ),
      SizedBox(height: 25),

      Wrap(
        spacing: 20,
        runSpacing: 12,
        children: [
          _buildCompactLink("Shop"),
          _buildCompactLink("Track Order"),
          _buildCompactLink("Contact"),
          _buildCompactLink("About"),
          _buildCompactLink("Privacy"),
          _buildCompactLink("Terms"),
        ],
      ),
    ],
  );
}

// Social Icon
Widget _buildSocialIcon(IconData icon, Color brandColor) {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            brandColor,
            brandColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: brandColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    ),
  );
}

// Payment Icon
Widget _buildPaymentIcon(IconData icon) {
  return Container(
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white24),
    ),
    child: Icon(icon, color: Colors.white60, size: 16),
  );
}

// Footer column
Widget _buildFooterColumn(String title, List<String> links) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 12),
      ...links.map((link) => _buildFooterLink(link)).toList(),
    ],
  );
}

// Footer link
Widget _buildFooterLink(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_right, size: 14, color: Color(0xFF4CAF50)),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    ),
  );
}

// Compact Link for mobile
Widget _buildCompactLink(String text) {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    ),
  );
}
