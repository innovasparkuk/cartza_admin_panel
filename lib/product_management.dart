// product_management.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_provider.dart';
// Add this import

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: _showBulkUploadDialog,
            tooltip: 'Bulk Upload',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductForm(context),
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(provider),

          // Products Table/List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildProductList(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection(AdminProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                provider.filterProducts(
                  value,
                  provider.categories
                      .firstWhere((cat) => cat != 'All', orElse: () => 'All'),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: provider.categories.firstWhere(
                  (cat) => cat != 'All',
              orElse: () => 'All',
            ),
            items: provider.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              provider.filterProducts('', value ?? 'All');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(AdminProvider provider) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return ListView.builder(
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final product = provider.products[index];
          return _buildMobileProductCard(product, provider);
        },
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Actions')),
        ],
        rows: provider.products.map((product) {
          return DataRow(cells: [
            DataCell(Text(product.id)),
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            DataCell(Text(product.category)),
            DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
            DataCell(
              Chip(
                label: Text(
                  product.stockQuantity.toString(),
                  style: TextStyle(
                    color: product.stockQuantity <= product.lowStockThreshold
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                backgroundColor:
                product.stockQuantity <= product.lowStockThreshold
                    ? Colors.red
                    : Colors.green.shade100,
              ),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showProductForm(context, product: product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _confirmDelete(product, provider),
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildMobileProductCard(Product product, AdminProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.category),
            Text('\$${product.price.toStringAsFixed(2)}'),
            Chip(
              label: Text('Stock: ${product.stockQuantity}'),
              backgroundColor: product.stockQuantity <= product.lowStockThreshold
                  ? Colors.red
                  : Colors.green.shade100,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showProductForm(context, product: product),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(product, provider),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductForm(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: ProductForm(
              product: product,
              onSave: (newProduct) {
                final provider = Provider.of<AdminProvider>(
                  context,
                  listen: false,
                );
                if (product == null) {
                  provider.addProduct(newProduct);
                } else {
                  provider.updateProduct(newProduct);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Product product, AdminProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProduct(product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted ${product.name}')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBulkUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Upload Products'),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Upload CSV file with product data'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Select CSV File'),
                onPressed: _handleFileUpload,
              ),
              const SizedBox(height: 20),
              const Text(
                'CSV Format: name,description,price,category,stock',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Download Template'),
          ),
        ],
      ),
    );
  }

  void _handleFileUpload() {
    // Implement file picker and CSV parsing
    // Use file_picker package for web
  }
}


class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductForm({
    super.key,
    this.product,
    required this.onSave,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _stockController;
  late TextEditingController _lowStockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.product?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stockQuantity.toString() ?? '',
    );
    _lowStockController = TextEditingController(
      text: widget.product?.lowStockThreshold.toString() ?? '10',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Form(
      key: _formKey,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: isMobile ? double.infinity : 300,
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 300,
            child: TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 150,
            child: TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 150,
            child: TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 150,
            child: TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter stock quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: isMobile ? double.infinity : 150,
            child: TextFormField(
              controller: _lowStockController,
              decoration: const InputDecoration(
                labelText: 'Low Stock Threshold',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter threshold';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProduct,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Save Product'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        category: _categoryController.text,
        stockQuantity: int.parse(_stockController.text),
        lowStockThreshold: int.parse(_lowStockController.text),
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      widget.onSave(product);
    }
  }
}