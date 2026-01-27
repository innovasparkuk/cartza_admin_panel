import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';

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
  late TextEditingController category;
  late TextEditingController stock;

  Uint8List? selectedImageBytes;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product?.name ?? '');
    desc = TextEditingController(text: widget.product?.description ?? '');
    price = TextEditingController(text: widget.product?.price.toString() ?? '');
    category = TextEditingController(text: widget.product?.category ?? '');
    stock = TextEditingController(
      text: widget.product?.stockQuantity.toString() ?? '',
    );
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
                    controller: category,
                    decoration: deco('Category'),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: stock,
                    decoration: deco('Stock'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                          category: category.text,
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
}
