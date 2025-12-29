// admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final allProducts = provider.allProducts;
    final lowStockCount = allProducts
        .where((p) => (p?.stockQuantity ?? 0) <= (p?.lowStockThreshold ?? 10))
        .length;
    final outOfStockCount = allProducts
        .where((p) => (p?.stockQuantity ?? 0) == 0)
        .length;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Dashboard Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Stats - Centered
              _buildQuickStats(provider, lowStockCount, outOfStockCount),

              const SizedBox(height: 32),

              // Recent Products - Centered
              _buildRecentProducts(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(
      AdminProvider provider,
      int lowStockCount,
      int outOfStockCount,
      ) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final totalProducts = provider.allProducts.length;

    if (isMobile) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              _buildStatCard(
                'Total Products',
                totalProducts.toString(),
                Icons.inventory,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Low Stock Items',
                lowStockCount.toString(),
                Icons.warning,
                Colors.orange,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Out of Stock',
                outOfStockCount.toString(),
                Icons.error,
                Colors.red,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Products',
                totalProducts.toString(),
                Icons.inventory,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Low Stock Items',
                lowStockCount.toString(),
                Icons.warning,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Out of Stock',
                outOfStockCount.toString(),
                Icons.error,
                Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProducts(AdminProvider provider) {
    final recentProducts = provider.allProducts
        .where((product) => product != null)
        .take(5)
        .toList();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Recent Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                recentProducts.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text(
                      'No products available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: recentProducts.map((product) {
                    if (product == null) return const SizedBox.shrink();

                    final stockQuantity = product.stockQuantity;
                    final lowStockThreshold = product.lowStockThreshold;
                    final productName = product.name;
                    final category = product.category;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          productName.isNotEmpty
                              ? productName[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(productName.isNotEmpty
                          ? productName
                          : 'Unnamed Product'),
                      subtitle: Text(category.isNotEmpty
                          ? category
                          : 'Uncategorized'),
                      trailing: Chip(
                        label: Text('Stock: $stockQuantity'),
                        backgroundColor: stockQuantity <= lowStockThreshold
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}