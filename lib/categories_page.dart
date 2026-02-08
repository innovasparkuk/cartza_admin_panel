import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../category_provider.dart';
import '../category_model.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryManagementPage();
  }
}

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({Key? key}) : super(key: key);

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage>
    with SingleTickerProviderStateMixin {
  CategoryModel? editingCategory;
  CategoryModel? _editingParentCategory;
  String? pendingDelete;
  Set<String> expandedCategories = {};
  bool showCategoryForm = false;
  String? showingSubcategoryForm;

  late AnimationController _taglineController;
  String selectedMenu = 'Categories';

  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productCountController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedStatus = 'Active';
  String _imageSource = 'url';
  String? _selectedImagePath;
  String? _selectedAssetImage;
  Uint8List? _selectedImageBytes; // ✅ For web
  final ImagePicker _picker = ImagePicker();

  final List<String> assetImages = [
    'assets/images/electronics.png',
    'assets/images/laptop.png',
    'assets/images/tablet.png',
    'assets/images/sports.png',
    'assets/images/books.png',
    'assets/images/toys.png',
  ];

  @override
  void initState() {
    super.initState();

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  List<CategoryModel> get categories =>
      context.watch<CategoryProvider>().categories;

  List<CategoryModel> get mainCategories =>
      context.watch<CategoryProvider>().mainCategories;

  int get totalProducts =>
      context.watch<CategoryProvider>().totalProducts;

  int get activeCount =>
      context.watch<CategoryProvider>().activeCategoriesCount;

  int get inactiveCount =>
      context.watch<CategoryProvider>().inactiveCategoriesCount;

  // ✅ UPDATED: Web-compatible image picker
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        // For web: read as bytes
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          final fileName = image.name.contains('.')
              ? image.name
              : 'category_${DateTime.now().millisecondsSinceEpoch}.png';

          _selectedImagePath = fileName;
          _imageUrlController.clear();
          _selectedAssetImage = null;
        });
      } else {
        // For mobile/desktop: use path
        setState(() {
          _selectedImagePath = image.path;
          _selectedImageBytes = null;
          _imageUrlController.clear();
          _selectedAssetImage = null;
        });
      }
    }
  }

  void _showAssetImagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image from Assets'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: assetImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAssetImage = assetImages[index];
                    _selectedImagePath = null;
                    _selectedImageBytes = null;
                    _imageUrlController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          assetImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 40);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          assetImages[index].split('/').last,
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCategoryForm({CategoryModel? category, CategoryModel? parent}) {
    editingCategory = category;
    _editingParentCategory = parent;

    if (category != null) {
      _categoryNameController.text = category.categoryName;
      _descriptionController.text = category.description;
      _productCountController.text = category.productCount.toString();
      _selectedStatus = category.status;
      _imageUrlController.text = category.imageUrl;
      _selectedImagePath = category.imagePath;
      _selectedImageBytes = null;

      if (category.imagePath != null && category.imagePath!.startsWith('assets/')) {
        _selectedAssetImage = category.imagePath;
        _imageSource = 'system';
      } else if (category.imagePath != null && category.imagePath!.isNotEmpty) {
        _imageSource = 'system';
      } else if (category.imageUrl.isNotEmpty) {
        _imageSource = 'url';
      } else {
        _imageSource = 'url';
      }
    } else {
      _categoryNameController.clear();
      _descriptionController.clear();
      _productCountController.text = '0';
      _selectedStatus = 'Active';
      _imageUrlController.clear();
      _selectedImagePath = null;
      _selectedAssetImage = null;
      _selectedImageBytes = null;
      _imageSource = 'url';
    }

    setState(() {
      showCategoryForm = true;
    });
  }

  void _hideCategoryForm() {
    setState(() {
      showCategoryForm = false;
      editingCategory = null;
      _editingParentCategory = null;
    });
  }

  void _showSubcategoryForm(String parentId) {
    setState(() {
      showingSubcategoryForm = parentId;
      expandedCategories.add(parentId);
      _categoryNameController.clear();
      _descriptionController.clear();
      _productCountController.text = '0';
      _selectedStatus = 'Active';
      _imageUrlController.clear();
      _selectedImagePath = null;
      _selectedAssetImage = null;
      _selectedImageBytes = null;
      _imageSource = 'url';
    });
  }

  void _hideSubcategoryForm() {
    setState(() {
      showingSubcategoryForm = null;
    });
  }

  // ✅ UPDATED: Web-compatible save category
  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CategoryProvider>();

    try {
      String finalImageUrl = '';
      String finalImagePath = '';

      // ✅ Handle image upload
      if (_imageSource == 'url') {
        finalImageUrl = _imageUrlController.text.trim();
      } else if (_imageSource == 'system') {
        if (_selectedAssetImage != null) {
          // Asset images - store path directly
          finalImagePath = _selectedAssetImage!;
        } else if (kIsWeb && _selectedImageBytes != null) {
          // Web: Upload bytes
          try {
            finalImageUrl = await ApiService.uploadCategoryImageBytes(
              _selectedImageBytes!,
              _selectedImagePath ?? 'category.png',
            );

            _showMessage('Image uploaded successfully', true);
          } catch (e) {
            _showMessage('Image upload failed: $e', false);
            return;
          }
        } else if (!kIsWeb && _selectedImagePath != null) {
          // Mobile/Desktop: Upload file
          try {
            finalImageUrl = await ApiService.uploadCategoryImage(_selectedImagePath!);
            _showMessage('Image uploaded successfully', true);
          } catch (e) {
            _showMessage('Image upload failed: $e', false);
            return;
          }
        }
      }

      if (editingCategory != null) {
        final updated = CategoryModel(
          id: editingCategory!.id,
          categoryName: _categoryNameController.text.trim(),
          description: _descriptionController.text.trim(),
          productCount: int.tryParse(_productCountController.text.trim()) ?? 0,
          status: _selectedStatus,
          parentId: editingCategory!.parentId,
          subcategoryCount: editingCategory!.subcategoryCount,
          createdAt: editingCategory!.createdAt,
          imageUrl: finalImageUrl,
          imagePath: finalImagePath,
        );

        await provider.updateCategory(updated);
        _showMessage('Category updated!', true);
      } else {
        final created = CategoryModel(
          id: '',
          categoryName: _categoryNameController.text.trim(),
          description: _descriptionController.text.trim(),
          productCount: int.tryParse(_productCountController.text.trim()) ?? 0,
          status: _selectedStatus,
          parentId: _editingParentCategory?.id ?? '',
          subcategoryCount: 0,
          createdAt: DateTime.now(),
          imageUrl: finalImageUrl,
          imagePath: finalImagePath,
        );

        await provider.addCategory(created);
        _showMessage('Category added!', true);
      }

      if (!mounted) return;
      _hideCategoryForm();
    } catch (e) {
      debugPrint(e.toString());
      _showMessage('Something went wrong: $e', false);
    }
  }

  // ✅ UPDATED: Web-compatible save subcategory
  Future<void> _saveSubcategory(String parentId) async {
    if (_categoryNameController.text.trim().isEmpty) {
      _showMessage('Please enter subcategory name', false);
      return;
    }

    try {
      String finalImageUrl = '';
      String finalImagePath = '';

      // ✅ Handle image upload
      if (_imageSource == 'url') {
        finalImageUrl = _imageUrlController.text.trim();
      } else if (_imageSource == 'system') {
        if (_selectedAssetImage != null) {
          finalImagePath = _selectedAssetImage!;
        } else if (kIsWeb && _selectedImageBytes != null) {
          try {
            finalImageUrl = await ApiService.uploadCategoryImageBytes(
              _selectedImageBytes!,
              _selectedImagePath ?? 'subcategory.png',
            );
          } catch (e) {
            _showMessage('Image upload failed: $e', false);
            return;
          }
        } else if (!kIsWeb && _selectedImagePath != null) {
          try {
            finalImageUrl = await ApiService.uploadCategoryImage(_selectedImagePath!);
          } catch (e) {
            _showMessage('Image upload failed: $e', false);
            return;
          }
        }
      }

      final newSubcategory = CategoryModel(
        id: '',
        categoryName: _categoryNameController.text.trim(),
        description: _descriptionController.text.trim(),
        productCount: int.tryParse(_productCountController.text.trim()) ?? 0,
        status: _selectedStatus,
        parentId: parentId,
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: finalImageUrl,
        imagePath: finalImagePath,
      );

      await context.read<CategoryProvider>().addCategory(newSubcategory);
      _showMessage('Subcategory added successfully!', true);
      _hideSubcategoryForm();
    } catch (e) {
      debugPrint(e.toString());
      _showMessage('Something went wrong: $e', false);
    }
  }

  void _deleteCategory(String id) {
    setState(() {
      pendingDelete = id;
    });
  }

  Future<void> _confirmDelete(String id) async {
    try {
      await context.read<CategoryProvider>().deleteCategory(id);

      setState(() {
        pendingDelete = null;
      });

      _showMessage('Category deleted successfully!', true);
    } catch (e) {
      _showMessage('Error: $e', false);
    }
  }

  void _cancelDelete() {
    setState(() {
      pendingDelete = null;
    });
  }

  void _toggleCategory(String id) {
    setState(() {
      if (expandedCategories.contains(id)) {
        expandedCategories.remove(id);
      } else {
        expandedCategories.add(id);
      }
    });
  }

  void _showMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  @override
  void dispose() {
    _taglineController.dispose();
    _categoryNameController.dispose();
    _descriptionController.dispose();
    _productCountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Management',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your product categories',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.count(
                        crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.4,
                        children: [
                          _buildStatCard('📁', mainCategories.length.toString(), 'Total Categories', const Color(0xFFFF6B35)),
                          _buildStatCard('📦', totalProducts.toString(), 'Total Products', const Color(0xFF3B82F6)),
                          _buildStatCard('✅', activeCount.toString(), 'Active', const Color(0xFF10B981)),
                          _buildStatCard('⏸️', inactiveCount.toString(), 'Inactive', const Color(0xFFEF4444)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'All Categories',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showCategoryForm(),
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text('Add New Category'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showCategoryForm) _buildCategoryForm(),
                        _buildCategoryTable(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter $label',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (value) {
            if (label != 'Image URL' && (value == null || value.isEmpty)) {
              return 'Please enter $label';
            }
            if (keyboardType == TextInputType.number && value != null && value.isNotEmpty && int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryForm() {
    final imageName =
        _selectedAssetImage?.split('/').last ??
            (_selectedImagePath != null
                ? _selectedImagePath!.split('/').last
                : '');

    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: _editingParentCategory != null
                        ? 'Subcategory Name'
                        : 'Category Name',
                    controller: _categoryNameController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    label: 'Description',
                    controller: _descriptionController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Product Count',
                    controller: _productCountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: ['Active', 'Inactive']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Image Source',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('URL'),
                        value: 'url',
                        groupValue: _imageSource,
                        onChanged: (value) {
                          setState(() {
                            _imageSource = value!;
                            _selectedImagePath = null;
                            _selectedAssetImage = null;
                            _selectedImageBytes = null;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('System'),
                        value: 'system',
                        groupValue: _imageSource,
                        onChanged: (value) {
                          setState(() {
                            _imageSource = value!;
                            _imageUrlController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_imageSource == 'url')
              _buildTextField(
                label: 'Image URL',
                controller: _imageUrlController,
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showAssetImagePicker,
                        icon: const Icon(Icons.folder),
                        label: const Text('Assets Folder'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (_selectedAssetImage != null || _selectedImagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _selectedAssetImage != null
                                  ? Image.asset(
                                _selectedAssetImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              )
                                  : kIsWeb && _selectedImageBytes != null
                                  ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
                                  : !kIsWeb && _selectedImagePath != null
                                  ? Image.file(File(_selectedImagePath!), fit: BoxFit.cover)
                                  : const Icon(Icons.image, size: 40),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              imageName,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _hideCategoryForm,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: mainCategories.map((category) {
          final subcategories = categories.where((cat) => cat.parentId == category.id).toList();
          final isExpanded = expandedCategories.contains(category.id);
          final isDeleting = pendingDelete == category.id;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildImageWidget(category),
                    const SizedBox(width: 7),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          if (subcategories.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                size: 20,
                              ),
                              onPressed: () => _toggleCategory(category.id),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          Expanded(
                            child: Text(
                              category.categoryName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 2,
                      child: Text(
                        category.description,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: Text(
                        category.productCount.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    SizedBox(width: 10),
                    _buildStatusBadge(category.status),
                    SizedBox(width: 14),
                    isDeleting
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Confirm?',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _confirmDelete(category.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: const Text('Yes', style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _cancelDelete,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            side: BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                          ),
                          child: const Text('No', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    )
                        : Wrap(
                      spacing: 28,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showCategoryForm(category: category),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _deleteCategory(category.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showSubcategoryForm(category.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Sub',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showingSubcategoryForm == category.id)
                Container(
                  margin: const EdgeInsets.only(left: 30, bottom: 12),
                  child: _buildSubcategoryFormInline(category.id),
                ),
              if (isExpanded)
                ...subcategories.map((sub) {
                  final isSubDeleting = pendingDelete == sub.id;
                  return Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildImageWidget(sub),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Text('└─ ', style: TextStyle(color: Colors.orange)),
                              Expanded(
                                child: Text(
                                  sub.categoryName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 48),
                        Expanded(
                          flex: 2,
                          child: Text(
                            sub.description,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 18),
                        SizedBox(
                          width: 60,
                          child: Text(
                            sub.productCount.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(sub.status, small: true),
                        const SizedBox(width: 8),
                        Flexible(
                          child: isSubDeleting
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Delete?',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 14),
                              ElevatedButton(
                                onPressed: () => _confirmDelete(sub.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  elevation: 0,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Yes', style: TextStyle(fontSize: 10)),
                              ),
                              SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: _cancelDelete,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('No', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          )
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 30),
                              ElevatedButton(
                                onPressed: () => _showCategoryForm(category: sub, parent: category),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF3F4F6),
                                  foregroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(8, 14),
                                  elevation: 0,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _deleteCategory(sub.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  elevation: 0,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageWidget(CategoryModel category) {
    Widget imageWidget;

    if (category.imagePath != null && category.imagePath!.startsWith('assets/')) {
      imageWidget = Image.asset(
        category.imagePath!,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && category.imagePath != null && category.imagePath!.isNotEmpty) {
      imageWidget = Image.file(
        File(category.imagePath!),
        fit: BoxFit.cover,
      );
    } else if (category.imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        category.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.grey, size: 25);
        },
      );
    } else {
      imageWidget = const Icon(Icons.image, color: Colors.grey, size: 25);
    }

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: imageWidget,
      ),
    );
  }

  Widget _buildStatusBadge(String status, {bool small = false}) {
    final isActive = status == 'Active';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isActive ? const Color(0xFF059669) : const Color(0xFFDC2626),
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSubcategoryFormInline(String parentId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '➕ Add Subcategory',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Subcategory Name',
                  controller: _categoryNameController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'Description',
                  controller: _descriptionController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Product Count',
                  controller: _productCountController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      items: ['Active', 'Inactive']
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'url',
                    groupValue: _imageSource,
                    onChanged: (value) => setState(() {
                      _imageSource = value!;
                      _selectedImagePath = null;
                      _selectedAssetImage = null;
                      _selectedImageBytes = null;
                    }),
                  ),
                  const Text('URL'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'system',
                    groupValue: _imageSource,
                    onChanged: (value) => setState(() {
                      _imageSource = value!;
                      _imageUrlController.clear();
                    }),
                  ),
                  const Text('System'),
                ],
              ),
              if (_imageSource == 'url')
                _buildTextField(
                  label: 'Image URL',
                  controller: _imageUrlController,
                )
              else
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAssetImagePicker,
                      icon: const Icon(Icons.folder, size: 16),
                      label: const Text('Assets', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Gallery', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    if (_selectedAssetImage != null || _selectedImagePath != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _selectedAssetImage != null
                              ? Image.asset(_selectedAssetImage!, fit: BoxFit.cover)
                              : kIsWeb && _selectedImageBytes != null
                              ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
                              : !kIsWeb && _selectedImagePath != null
                              ? Image.file(File(_selectedImagePath!), fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 40),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _saveSubcategory(parentId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text('Save'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _hideSubcategoryForm,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}