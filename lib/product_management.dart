import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_provider.dart';
import '../models/product.dart';
import '../product_form.dart';
import 'stock_management.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory),
            tooltip: 'Stock Management',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StockManagementPage(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
            onPressed: () => _showProductForm(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
