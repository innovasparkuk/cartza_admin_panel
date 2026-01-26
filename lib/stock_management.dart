import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_provider.dart';
import '../models/product.dart';


class StockManagementPage extends StatefulWidget {
  const StockManagementPage({super.key});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  final Map<String, TextEditingController> _stockControllers = {};

  @override
  void dispose() {
    _stockControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final allProducts = provider.products;

    final lowStockProducts = allProducts
        .where((p) => p.stockQuantity <= p.lowStockThreshold)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Stock Summary Cards - Centered
              _buildStockSummary(allProducts),

              const SizedBox(height: 32),

              // Low Stock Alert - Centered
              if (lowStockProducts.isNotEmpty)
                _buildLowStockAlert(lowStockProducts),

              const SizedBox(height: 32),

              // Bulk Stock Update - Centered
              _buildBulkUpdateSection(allProducts, provider),

              const SizedBox(height: 32),

              // Stock History/Logs - Centered
              _buildStockHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockSummary(List<Product> allProducts) {
    final totalProducts = allProducts.length;
    final totalStock = allProducts.fold<int>(
        0,
            (sum, product) => sum + product.stockQuantity
    );
    final outOfStock = allProducts
        .where((p) => p.stockQuantity == 0)
        .length;
    final lowStock = allProducts
        .where((p) => p.stockQuantity > 0 && p.stockQuantity <= p.lowStockThreshold)
        .length;

    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Center(
        child: Column(
          children: [
            _buildSummaryCard('Total Products', totalProducts.toString()),
            _buildSummaryCard('Total Stock', totalStock.toString()),
            _buildSummaryCard('Out of Stock', outOfStock.toString()),
            _buildSummaryCard('Low Stock', lowStock.toString()),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Row(
          children: [
            Expanded(child: _buildSummaryCard('Total Products', totalProducts.toString())),
            Expanded(child: _buildSummaryCard('Total Stock', totalStock.toString())),
            Expanded(child: _buildSummaryCard('Out of Stock', outOfStock.toString())),
            Expanded(child: _buildSummaryCard('Low Stock', lowStock.toString())),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
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
    );
  }

  Widget _buildLowStockAlert(List<Product> lowStockProducts) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Text(
                      'Low Stock Alert',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('${lowStockProducts.length} products'),
                      backgroundColor: Colors.orange.shade100,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lowStockProducts.length,
                    itemBuilder: (context, index) {
                      final product = lowStockProducts[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Current stock: ${product.stockQuantity}'),
                        trailing: ElevatedButton(
                          onPressed: () => _quickRestock(product),
                          child: const Text('Restock'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulkUpdateSection(List<Product> allProducts, AdminProvider provider) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Bulk Stock Update',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allProducts.length,
                    itemBuilder: (context, index) {
                      final product = allProducts[index];
                      _stockControllers[product.id] ??= TextEditingController(
                        text: product.stockQuantity.toString(),
                      );

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text('Category: ${product.category}'),
                          trailing: SizedBox(
                            width: 120,
                            child: TextField(
                              controller: _stockControllers[product.id]!,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'Stock',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Update All Stock'),
                    onPressed: () => _bulkUpdateStock(provider),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockHistory() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Recent Stock Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 32,
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Change')),
                      DataColumn(label: Text('New Stock')),
                    ],
                    rows: const [
                      // Populate with actual data
                      DataRow(cells: [
                        DataCell(Text('2024-01-15')),
                        DataCell(Text('Product 1')),
                        DataCell(Text('+50')),
                        DataCell(Text('150')),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _quickRestock(Product product) {
    final quantityController = TextEditingController(text: '50');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restock ${product.name}'),
        content: TextFormField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity to add',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement restock logic
              final quantity = int.tryParse(quantityController.text);
              if (quantity != null && quantity > 0) {
                // Call provider method to update stock
                final provider = Provider.of<AdminProvider>(context, listen: false);
                // You need to implement a restock method in AdminProvider
                // provider.restockProduct(product.id, quantity);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Stock'),
          ),
        ],
      ),
    );
  }

  void _bulkUpdateStock(AdminProvider provider) {
    final updates = <Map<String, dynamic>>[];

    for (final entry in _stockControllers.entries) {
      final productId = entry.key;
      final controller = entry.value;
      final newStock = int.tryParse(controller.text);

      if (newStock != null && newStock >= 0) {
        updates.add({
          'productId': productId,
          'stock': newStock,
        });
      }
    }

    if (updates.isNotEmpty) {
      provider.bulkUpdateStock(updates);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock updated successfully')),
      );
    }
  }
}