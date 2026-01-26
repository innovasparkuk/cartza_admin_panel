import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductForm({super.key, this.product, required this.onSave});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController desc;
  late TextEditingController price;
  late TextEditingController category;
  late TextEditingController stock;
  late TextEditingController lowStock;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product?.name ?? '');
    desc = TextEditingController(text: widget.product?.description ?? '');
    price = TextEditingController(text: widget.product?.price.toString() ?? '');
    category = TextEditingController(text: widget.product?.category ?? '');
    stock = TextEditingController(text: widget.product?.stockQuantity.toString() ?? '');
    lowStock = TextEditingController(text: widget.product?.lowStockThreshold.toString() ?? '10');
  }

  InputDecoration _inputDecoration(String label, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.product == null ? 'Add Product' : 'Edit Product',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: name,
                  decoration: _inputDecoration('Product Name'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter product name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: desc,
                  decoration: _inputDecoration('Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: price,
                  decoration: _inputDecoration('Price', prefix: '\$ '),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: category,
                  decoration: _inputDecoration('Category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stock,
                  decoration: _inputDecoration('Stock Quantity'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: lowStock,
                  decoration: _inputDecoration('Low Stock Threshold'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final p = Product(
                          id: widget.product?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name.text,
                          description: desc.text,
                          price: double.tryParse(price.text) ?? 0,
                          category: category.text,
                          stockQuantity: int.tryParse(stock.text) ?? 0,
                          lowStockThreshold: int.tryParse(lowStock.text) ?? 10,
                          createdAt: widget.product?.createdAt ?? DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                        widget.onSave(p);
                      }
                    },
                    child: const Text('Save', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
