import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_provider.dart';
import '../models/product.dart';
import '../product_form.dart';
import 'stock_management.dart';
import 'review.dart';
class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadProducts();
    });
  }
  void _openProductReviews(Product product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ReviewsPage(
        productId: product.id,
        productName: product.name,
      ),
    ));
  }

  void _openAllReviews() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const ReviewsPage()));
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();
    final isMobile = MediaQuery.of(context).size.width < 800;
    Widget _actionButton({
      required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap,
    }) {
      return ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Management',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Manage your products',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    _actionButton(
                      icon: Icons.rate_review_rounded,
                      label: 'Reviews',
                      color: const Color(0xFFFF6B35),
                      onTap: _openAllReviews,
                    ),
                    const SizedBox(width: 8),
                    _actionButton(
                      icon: Icons.inventory,
                      label: 'Stock',
                      color: const Color(0xFF2196F3),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const StockManagementPage())),
                    ),
                    const SizedBox(width: 8),
                    _actionButton(
                      icon: Icons.add,
                      label: 'Add Product',
                      color: const Color(0xFF4CAF50),
                      onTap: () => _showProductForm(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSearchFilterSection(provider),
            const SizedBox(height: 16),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : isMobile
                  ? ListView.builder(
                itemCount: provider.products.length,
                itemBuilder: (_, index) {
                  return _buildMobileCard(
                      provider.products[index]);
                },
              )
                  : _buildDesktopTable(provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(AdminProvider provider) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: DataTable(
            headingRowHeight: 56,
            dataRowHeight: 80,
            columnSpacing: 24,
            columns: const [
              DataColumn(
                label: Text(
                  'Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              DataColumn(
                label: Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              DataColumn(
                label: Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              DataColumn(
                label: Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              DataColumn(
                label: Text(
                  'Stock',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
            rows: provider.products.map((product) {
              return DataRow(cells: [
                DataCell(
                  product.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      product.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
                DataCell(Text(product.name)),
                DataCell(
                  SizedBox(
                    width: 220,
                    child: Text(
                      product.description.isNotEmpty
                          ? product.description
                          : 'No description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(product.category)),
                DataCell(
                    Text('\$${product.price.toStringAsFixed(2)}')),
                DataCell(Text(product.stockQuantity.toString())),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () =>
                            _showProductForm(product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 18, color: Colors.red),
                        onPressed: () => _confirmDelete(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.rate_review_rounded,
                            size: 18, color: Color(0xFFFF6B35)),
                        tooltip: 'View Reviews',
                        onPressed: () => _openProductReviews(product),
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFilterSection(AdminProvider provider) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) {
              provider.filterProducts(value, provider.selectedCategory);
            },
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: provider.categories.contains(provider.selectedCategory)
              ? provider.selectedCategory
              : 'All',
          items: provider.categories.map((cat) {
            return DropdownMenuItem(value: cat, child: Text(cat));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.filterProducts('', value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMobileCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: product.imageUrl.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        )
            : const Icon(Icons.image),
        title: Text(product.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${product.category} | \$${product.price}\n${product.description}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showProductForm(product: product),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(product),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductForm({Product? product}) {
    showDialog(
      context: context,
      builder: (_) => ProductForm(
        product: product,
        onSave: (p, imageFile) {
          final provider = context.read<AdminProvider>();
          if (product == null) {
            provider.addProduct(p, imageFile, context);
          } else {
            provider.updateProduct(p, imageFile, context);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<AdminProvider>()
                  .deleteProduct(product.id, context);
              Navigator.pop(context);
            },
            child:
            const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBulkUploadDialog() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Bulk upload'),
        content: Text('CSV upload coming soon'),
      ),
    );
  }
}
