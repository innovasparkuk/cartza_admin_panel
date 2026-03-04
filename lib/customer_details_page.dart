// customer_details_page.dart
import 'package:flutter/material.dart';
 // Add this import

class CustomerDetailsPage extends StatefulWidget {
  final Customer customer;
  final Function(Customer) onBlockToggle;
  final Function(Customer) onSendPromotion;

  const CustomerDetailsPage({
    super.key,
    required this.customer,
    required this.onBlockToggle,
    required this.onSendPromotion,
  });

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

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
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    customer.name.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.phone,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // Stats
            const Text(
              'Customer Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
              children: [
                _buildStatItem('Customer ID', customer.id),
                _buildStatItem('Total Orders', '${customer.totalOrders}'),
                _buildStatItem(
                  'Join Date',
                  '${customer.joinDate.day}/${customer.joinDate.month}/${customer.joinDate.year}',
                ),
                _buildStatItem(
                  'Last Active',
                  '${_formatDateTime(customer.lastActive)}',
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.onBlockToggle(customer);
                      setState(() {});
                    },
                    icon: Icon(
                      customer.status == CustomerStatus.blocked
                          ? Icons.lock_open
                          : Icons.block,
                    ),
                    label: Text(
                      customer.status == CustomerStatus.blocked
                          ? 'Unblock Customer'
                          : 'Block Customer',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: customer.status == CustomerStatus.blocked
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onSendPromotion(customer),
                    icon: const Icon(Icons.send),
                    label: const Text('Send Promotion'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                // View order history
              },
              icon: const Icon(Icons.history),
              label: const Text('View Order History'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
// customer_model.dart
enum CustomerStatus {
  active,
  blocked,
  inactive;

  String get name {
    switch (this) {
      case CustomerStatus.active:
        return 'Active';
      case CustomerStatus.blocked:
        return 'Blocked';
      case CustomerStatus.inactive:
        return 'Inactive';
    }
  }
}

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  CustomerStatus status;
  final DateTime joinDate;
  final int totalOrders;
  final DateTime lastActive;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.joinDate,
    required this.totalOrders,
    required this.lastActive,
  });
}

// REMOVE THESE DUPLICATE CLASSES FROM HERE
// They are now in customer_model.dart file