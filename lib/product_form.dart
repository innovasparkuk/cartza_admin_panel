import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../category_provider.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product, Uint8List?) onSave;

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

  late TextEditingController name;
  late TextEditingController desc;
  late TextEditingController price;
  late TextEditingController stock;

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  Uint8List? selectedImageBytes;

  @override
  void initState() {
    super.initState();

    // Load categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });

    name = TextEditingController(text: widget.product?.name ?? '');
    desc = TextEditingController(text: widget.product?.description ?? '');
    price = TextEditingController(text: widget.product?.price.toString() ?? '');
    stock = TextEditingController(
      text: widget.product?.stockQuantity.toString() ?? '',
    );

    // ✅ Initialize category selection
    if (widget.product != null) {
      _selectedCategoryId = widget.product!.categoryId;
      _selectedCategoryName = widget.product!.category;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() {
        selectedImageBytes = bytes;
      });
    }
  }

  InputDecoration deco(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final categories = context.watch<CategoryProvider>().categories
        .where((c) => c.status == 'Active' && c.parentId.isEmpty)
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 520,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.product == null ? 'Add Product' : 'Edit Product',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: selectedImageBytes != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          selectedImageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : widget.product?.imageUrl.isNotEmpty == true
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.product!.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Center(child: Text('Select image')),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: name,
                    decoration: deco('Name'),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),

                  // ✅ Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: deco('Category'),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.categoryName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                        _selectedCategoryName = categories
                            .firstWhere((c) => c.id == value)
                            .categoryName;
                      });
                    },
                    validator: (v) =>
                    v == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: desc,
                    decoration: deco('Description'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: price,
                    decoration: deco('Price'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'\d+\.?\d*'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: stock,
                    decoration: deco('Stock'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        final product = Product(
                          id: widget.product?.id ??
                              DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                          name: name.text,
                          description: desc.text,
                          price: double.tryParse(price.text) ?? 0,
                          category: _selectedCategoryName ?? '',
                          categoryId: _selectedCategoryId ?? '', // ✅ ADDED
                          stockQuantity: int.tryParse(stock.text) ?? 0,
                          imageUrl: widget.product?.imageUrl ?? '',
                          createdAt:
                          widget.product?.createdAt ?? DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        widget.onSave(product, selectedImageBytes);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    name.dispose();
    desc.dispose();
    price.dispose();
    stock.dispose();
    super.dispose();
  }
}