
import 'package:flutter/material.dart';
//import 'customer_model.dart';  // Add this import
import 'customer_details_page.dart';

class CustomerManagementDashboard extends StatefulWidget {
  const CustomerManagementDashboard({super.key});

  @override
  State<CustomerManagementDashboard> createState() => _CustomerManagementDashboardState();
}

class _CustomerManagementDashboardState extends State<CustomerManagementDashboard> {
  final List<Customer> customers = [
    Customer(
      id: '001',
      name: 'Areeba Khan',
      email: 'areeba.khan@example.com',
      phone: '+923001234567',
      status: CustomerStatus.active,
      joinDate: DateTime(2024, 1, 15),
      totalOrders: 42,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Customer(
      id: '002',
      name: 'Ali Ahmed',
      email: 'ali.ahmed@example.com',
      phone: '+923331234567',
      status: CustomerStatus.blocked,
      joinDate: DateTime(2023, 11, 20),
      totalOrders: 18,
      lastActive: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Customer(
      id: '003',
      name: 'Sana Malik',
      email: 'sana.malik@example.com',
      phone: '+923221234567',
      status: CustomerStatus.active,
      joinDate: DateTime(2024, 2, 10),
      totalOrders: 27,
      lastActive: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Customer(
      id: '004',
      name: 'Omar Farooq',
      email: 'omar.farooq@example.com',
      phone: '+923441234567',
      status: CustomerStatus.inactive,
      joinDate: DateTime(2023, 9, 5),
      totalOrders: 5,
      lastActive: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Customer(
      id: '005',
      name: 'Fatima Zain',
      email: 'fatima.zain@example.com',
      phone: '+923551234567',
      status: CustomerStatus.active,
      joinDate: DateTime(2024, 3, 22),
      totalOrders: 35,
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  TextEditingController searchController = TextEditingController();
  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    filteredCustomers = customers;
    searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCustomers = customers;
      } else {
        filteredCustomers = customers.where((customer) {
          return customer.name.toLowerCase().contains(query) ||
              customer.email.toLowerCase().contains(query) ||
              customer.phone.contains(query);
        }).toList();
      }
    });
  }

  void _toggleBlockStatus(Customer customer) {
    setState(() {
      customer.status = customer.status == CustomerStatus.blocked
          ? CustomerStatus.active
          : CustomerStatus.blocked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          customer.status == CustomerStatus.blocked
              ? '${customer.name} has been blocked'
              : '${customer.name} has been unblocked',
        ),
      ),
    );
  }

  void _sendPromotion(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => PromotionDialog(customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.people, size: 28),
            SizedBox(width: 12),
            Text(
              'Customer Management',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 1200;
          final isMediumScreen = constraints.maxWidth > 768;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(isLargeScreen),
                const SizedBox(height: 24),

                // Stats Cards
                _buildStatsSection(isLargeScreen),
                const SizedBox(height: 24),

                // Main Content
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customers List
                      Expanded(
                        flex: isLargeScreen ? 2 : 1,
                        child: _buildCustomersList(isLargeScreen, isMediumScreen),
                      ),

                      if (isLargeScreen) const SizedBox(width: 24),

                      // Customer Details (Only shown on large screens)
                      if (isLargeScreen)
                        Expanded(
                          flex: 3,
                          child: CustomerDetailsPage(
                            customer: customers.first,
                            onBlockToggle: (customer) => _toggleBlockStatus(customer),
                            onSendPromotion: (customer) => _sendPromotion(customer),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(bool isLargeScreen) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search customers by name, email, or phone...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (isLargeScreen)
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('Export Data'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsSection(bool isLargeScreen) {
    final activeCustomers = customers.where((c) => c.status == CustomerStatus.active).length;
    final blockedCustomers = customers.where((c) => c.status == CustomerStatus.blocked).length;

    return SizedBox(
      height: isLargeScreen ? 120 : 160,
      child: isLargeScreen
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatCard(
            title: 'Total Customers',
            value: customers.length.toString(),
            icon: Icons.people_outline,
            color: Colors.blue,
            isLargeScreen: true,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            title: 'Active Customers',
            value: activeCustomers.toString(),
            icon: Icons.check_circle_outline,
            color: Colors.green,
            isLargeScreen: true,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            title: 'Blocked Customers',
            value: blockedCustomers.toString(),
            icon: Icons.block,
            color: Colors.red,
            isLargeScreen: true,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            title: 'Avg Orders',
            value: (customers.fold(0, (sum, c) => sum + c.totalOrders) / customers.length)
                .toStringAsFixed(1),
            icon: Icons.shopping_cart_outlined,
            color: Colors.purple,
            isLargeScreen: true,
          ),
        ],
      )
          : Center(
        child: Container(
          width: 400, // Fixed width for mobile
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                title: 'Total Customers',
                value: customers.length.toString(),
                icon: Icons.people_outline,
                color: Colors.blue,
                isLargeScreen: false,
              ),
              _buildStatCard(
                title: 'Active Customers',
                value: activeCustomers.toString(),
                icon: Icons.check_circle_outline,
                color: Colors.green,
                isLargeScreen: false,
              ),
              _buildStatCard(
                title: 'Blocked Customers',
                value: blockedCustomers.toString(),
                icon: Icons.block,
                color: Colors.red,
                isLargeScreen: false,
              ),
              _buildStatCard(
                title: 'Avg Orders',
                value: (customers.fold(0, (sum, c) => sum + c.totalOrders) / customers.length)
                    .toStringAsFixed(1),
                icon: Icons.shopping_cart_outlined,
                color: Colors.purple,
                isLargeScreen: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isLargeScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: isLargeScreen
          ? const EdgeInsets.all(20)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersList(bool isLargeScreen, bool isMediumScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // List Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                if (isMediumScreen)
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Customer',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                if (!isMediumScreen)
                  const Expanded(
                    child: Text(
                      'Customer',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                if (isMediumScreen)
                  Expanded(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                if (isMediumScreen)
                  Expanded(
                    child: Text(
                      'Orders',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                const Expanded(
                  child: Text(
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // List Items
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return CustomerListItem(
                  customer: customer,
                  isLargeScreen: isLargeScreen,
                  isMediumScreen: isMediumScreen,
                  onTap: () {
                    if (!isLargeScreen) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerDetailsPage(
                            customer: customer,
                            onBlockToggle: (customer) => _toggleBlockStatus(customer),
                            onSendPromotion: (customer) => _sendPromotion(customer),
                          ),
                        ),
                      );
                    }
                  },
                  onBlockToggle: () => _toggleBlockStatus(customer),
                  onSendPromotion: () => _sendPromotion(customer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerListItem extends StatelessWidget {
  final Customer customer;
  final bool isLargeScreen;
  final bool isMediumScreen;
  final VoidCallback onTap;
  final VoidCallback onBlockToggle;
  final VoidCallback onSendPromotion;

  const CustomerListItem({
    super.key,
    required this.customer,
    required this.isLargeScreen,
    required this.isMediumScreen,
    required this.onTap,
    required this.onBlockToggle,
    required this.onSendPromotion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          children: [
            // Customer Avatar and Info
            Expanded(
              flex: isMediumScreen ? 2 : 1,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      customer.name.substring(0, 1),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer.email,
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!isMediumScreen) ...[
                          const SizedBox(height: 4),
                          Text(
                            customer.phone,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Status (only on medium+ screens)
            if (isMediumScreen)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: customer.status == CustomerStatus.active
                        ? Colors.green.withOpacity(0.1)
                        : customer.status == CustomerStatus.blocked
                        ? Colors.red.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    customer.status.name.toUpperCase(),
                    style: TextStyle(
                      color: customer.status == CustomerStatus.active
                          ? Colors.green
                          : customer.status == CustomerStatus.blocked
                          ? Colors.red
                          : Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Orders (only on medium+ screens)
            if (isMediumScreen)
              Expanded(
                child: Text(
                  '${customer.totalOrders} orders',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Actions
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      customer.status == CustomerStatus.blocked
                          ? Icons.lock_open
                          : Icons.block,
                      color: customer.status == CustomerStatus.blocked
                          ? Colors.green
                          : Colors.red,
                    ),
                    onPressed: onBlockToggle,
                    tooltip: customer.status == CustomerStatus.blocked
                        ? 'Unblock Customer'
                        : 'Block Customer',
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: onSendPromotion,
                    tooltip: 'Send Promotion',
                  ),
                  if (!isLargeScreen)
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.grey),
                      onPressed: onTap,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromotionDialog extends StatefulWidget {
  final Customer customer;

  const PromotionDialog({super.key, required this.customer});

  @override
  State<PromotionDialog> createState() => _PromotionDialogState();
}

class _PromotionDialogState extends State<PromotionDialog> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  bool _includeAllCustomers = false;

  @override
  void dispose() {
    messageController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Promotion'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_includeAllCustomers)
              Text('To: ${widget.customer.name} (${widget.customer.email})'),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Send to all customers'),
              value: _includeAllCustomers,
              onChanged: (value) {
                setState(() {
                  _includeAllCustomers = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Promotion Message',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can use {name} placeholder for customer name',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final message = messageController.text;
            final subject = subjectController.text;
            if (message.isNotEmpty && subject.isNotEmpty) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _includeAllCustomers
                        ? 'Promotion sent to all customers'
                        : 'Promotion sent to ${widget.customer.name}',
                  ),
                ),
              );
            }
          },
          child: const Text('Send Promotion'),
        ),
      ],
    );
  }
}

// REMOVE THESE DUPLICATE CLASSES FROM HERE
// They are now in customer_model.dart file