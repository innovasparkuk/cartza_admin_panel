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
  Widget build(BuildContext context) => const CategoryManagementPage();
}

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({Key? key}) : super(key: key);
  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  CategoryModel? editingCategory;
  CategoryModel? _editingParentCategory;
  String? pendingDelete;
  final Set<String> expandedCategories = {};
  bool showCategoryForm = false;
  String? showingSubcategoryForm;

  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productCountController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedStatus = 'Active';
  String _imageSource = 'url';
  String? _selectedImagePath;
  String? _selectedAssetImage;
  Uint8List? _selectedImageBytes;
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
    // Load once — use listen:false to avoid rebuild trigger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _descriptionController.dispose();
    _productCountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // ── Image helpers ────────────────────────────────────────────
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImagePath = image.name.contains('.') ? image.name : 'category_${DateTime.now().millisecondsSinceEpoch}.png';
        _imageUrlController.clear();
        _selectedAssetImage = null;
      });
    } else {
      setState(() {
        _selectedImagePath = image.path;
        _selectedImageBytes = null;
        _imageUrlController.clear();
        _selectedAssetImage = null;
      });
    }
  }

  void _showAssetImagePicker() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text('Select Image from Assets', style: TextStyle(color: theme.textTheme.titleLarge?.color)),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: assetImages.length,
            itemBuilder: (context, index) => GestureDetector(
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
                decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(assetImages[index], fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.image, size: 40, color: theme.iconTheme.color)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(assetImages[index].split('/').last, style: theme.textTheme.bodySmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: theme.primaryColor)))],
      ),
    );
  }

  // ── Form helpers ─────────────────────────────────────────────
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
    setState(() => showCategoryForm = true);
  }

  void _hideCategoryForm() => setState(() { showCategoryForm = false; editingCategory = null; _editingParentCategory = null; });

  void _showSubcategoryForm(String parentId) {
    _categoryNameController.clear();
    _descriptionController.clear();
    _productCountController.text = '0';
    _selectedStatus = 'Active';
    _imageUrlController.clear();
    _selectedImagePath = null;
    _selectedAssetImage = null;
    _selectedImageBytes = null;
    _imageSource = 'url';
    setState(() { showingSubcategoryForm = parentId; expandedCategories.add(parentId); });
  }

  void _hideSubcategoryForm() => setState(() => showingSubcategoryForm = null);

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<CategoryProvider>();
    try {
      String finalImageUrl = '';
      String finalImagePath = '';
      if (_imageSource == 'url') {
        finalImageUrl = _imageUrlController.text.trim();
      } else {
        if (_selectedAssetImage != null) {
          finalImagePath = _selectedAssetImage!;
        } else if (kIsWeb && _selectedImageBytes != null) {
          try {
            finalImageUrl = await ApiService.uploadCategoryImageBytes(_selectedImageBytes!, _selectedImagePath ?? 'category.png');
            _showMessage('Image uploaded successfully', true);
          } catch (e) { _showMessage('Image upload failed: $e', false); return; }
        } else if (!kIsWeb && _selectedImagePath != null) {
          try {
            finalImageUrl = await ApiService.uploadCategoryImage(_selectedImagePath!);
            _showMessage('Image uploaded successfully', true);
          } catch (e) { _showMessage('Image upload failed: $e', false); return; }
        }
      }

      if (editingCategory != null) {
        await provider.updateCategory(CategoryModel(
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
        ));
        _showMessage('Category updated!', true);
      } else {
        await provider.addCategory(CategoryModel(
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
        ));
        _showMessage('Category added!', true);
      }
      if (!mounted) return;
      _hideCategoryForm();
    } catch (e) {
      _showMessage('Something went wrong: $e', false);
    }
  }

  Future<void> _saveSubcategory(String parentId) async {
    if (_categoryNameController.text.trim().isEmpty) { _showMessage('Please enter subcategory name', false); return; }
    try {
      String finalImageUrl = '';
      String finalImagePath = '';
      if (_imageSource == 'url') {
        finalImageUrl = _imageUrlController.text.trim();
      } else {
        if (_selectedAssetImage != null) {
          finalImagePath = _selectedAssetImage!;
        } else if (kIsWeb && _selectedImageBytes != null) {
          try { finalImageUrl = await ApiService.uploadCategoryImageBytes(_selectedImageBytes!, _selectedImagePath ?? 'subcategory.png'); }
          catch (e) { _showMessage('Image upload failed: $e', false); return; }
        } else if (!kIsWeb && _selectedImagePath != null) {
          try { finalImageUrl = await ApiService.uploadCategoryImage(_selectedImagePath!); }
          catch (e) { _showMessage('Image upload failed: $e', false); return; }
        }
      }
      await context.read<CategoryProvider>().addCategory(CategoryModel(
        id: '', categoryName: _categoryNameController.text.trim(),
        description: _descriptionController.text.trim(),
        productCount: int.tryParse(_productCountController.text.trim()) ?? 0,
        status: _selectedStatus, parentId: parentId, subcategoryCount: 0,
        createdAt: DateTime.now(), imageUrl: finalImageUrl, imagePath: finalImagePath,
      ));
      _showMessage('Subcategory added successfully!', true);
      _hideSubcategoryForm();
    } catch (e) { _showMessage('Something went wrong: $e', false); }
  }

  void _deleteCategory(String id) => setState(() => pendingDelete = id);

  Future<void> _confirmDelete(String id) async {
    try {
      await context.read<CategoryProvider>().deleteCategory(id);
      setState(() => pendingDelete = null);
      _showMessage('Category deleted successfully!', true);
    } catch (e) { _showMessage('Error: $e', false); }
  }

  void _cancelDelete() => setState(() => pendingDelete = null);

  void _toggleCategory(String id) => setState(() {
    expandedCategories.contains(id) ? expandedCategories.remove(id) : expandedCategories.add(id);
  });

  void _showMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(24),
    ));
  }

  // ── BUILD ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ Use Selector instead of watch — only rebuilds when specific values change
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category Management',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: theme.textTheme.titleLarge?.color)),
            const SizedBox(height: 8),
            Text('Manage your product categories',
                style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6))),
            const SizedBox(height: 32),

            // ── Stats — only rebuild when counts change ──────────
            Selector<CategoryProvider, _StatsData>(
              selector: (_, p) => _StatsData(p.mainCategories.length, p.totalProducts, p.activeCategoriesCount, p.inactiveCategoriesCount),
              builder: (context, stats, __) => LayoutBuilder(
                builder: (context, constraints) => GridView.count(
                  crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.4,
                  children: [
                    _buildStatCard('📁', stats.total.toString(), 'Total Categories', const Color(0xFFFF6B35), isDark),
                    _buildStatCard('📦', stats.products.toString(), 'Total Products', const Color(0xFF3B82F6), isDark),
                    _buildStatCard('✅', stats.active.toString(), 'Active', const Color(0xFF10B981), isDark),
                    _buildStatCard('⏸️', stats.inactive.toString(), 'Inactive', const Color(0xFFEF4444), isDark),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Category table card ──────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
                boxShadow: [BoxShadow(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 1))],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('All Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.textTheme.titleLarge?.color)),
                        ElevatedButton.icon(
                          onPressed: () => _showCategoryForm(),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add New Category'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showCategoryForm) _buildCategoryForm(theme),

                  // ✅ Only category list rebuilds when categories change
                  Selector<CategoryProvider, List<CategoryModel>>(
                    selector: (_, p) => p.categories,
                    builder: (context, allCats, __) {
                      final mainCats = allCats.where((c) => c.parentId.isEmpty).toList();
                      return _buildCategoryTable(theme, isDark, allCats, mainCats);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String icon, String value, String label, Color color, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [BoxShadow(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: theme.textTheme.titleLarge?.color)),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType keyboardType = TextInputType.text, required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: theme.hintColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (value) {
            if (label != 'Image URL' && (value == null || value.isEmpty)) return 'Please enter $label';
            if (keyboardType == TextInputType.number && value != null && value.isNotEmpty && int.tryParse(value) == null) return 'Please enter a valid number';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryForm(ThemeData theme) {
    final imageName = _selectedAssetImage?.split('/').last ?? (_selectedImagePath != null ? _selectedImagePath!.split('/').last : '');
    return Container(
      padding: const EdgeInsets.all(24),
      color: theme.cardColor,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(children: [
              Expanded(child: _buildTextField(label: _editingParentCategory != null ? 'Subcategory Name' : 'Category Name', controller: _categoryNameController, theme: theme)),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField(label: 'Description', controller: _descriptionController, theme: theme)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildTextField(label: 'Product Count', controller: _productCountController, keyboardType: TextInputType.number, theme: theme)),
              const SizedBox(width: 5),
              Expanded(child: _statusDropdown(theme)),
            ]),
            const SizedBox(height: 16),
            _imageSourceSelector(theme),
            const SizedBox(height: 16),
            if (_imageSource == 'url')
              _buildTextField(label: 'Image URL', controller: _imageUrlController, theme: theme)
            else
              _systemImagePicker(theme, imageName),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _hideCategoryForm,
                  style: TextButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          items: ['Active', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: theme.textTheme.bodyMedium))).toList(),
          onChanged: (v) => setState(() => _selectedStatus = v!),
          decoration: InputDecoration(
            filled: true, fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          dropdownColor: theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white,
        ),
      ],
    );
  }

  Widget _imageSourceSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image Source', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: RadioListTile<String>(
            title: Text('URL', style: theme.textTheme.bodyMedium), value: 'url', groupValue: _imageSource, activeColor: Colors.green,
            onChanged: (v) => setState(() { _imageSource = v!; _selectedImagePath = null; _selectedAssetImage = null; _selectedImageBytes = null; }),
          )),
          Expanded(child: RadioListTile<String>(
            title: Text('System', style: theme.textTheme.bodyMedium), value: 'system', groupValue: _imageSource, activeColor: Colors.green,
            onChanged: (v) => setState(() { _imageSource = v!; _imageUrlController.clear(); }),
          )),
        ]),
      ],
    );
  }

  Widget _systemImagePicker(ThemeData theme, String imageName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          ElevatedButton.icon(onPressed: _showAssetImagePicker, icon: const Icon(Icons.folder), label: const Text('Assets Folder'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white)),
          const SizedBox(width: 10),
          ElevatedButton.icon(onPressed: _pickImageFromGallery, icon: const Icon(Icons.photo_library), label: const Text('Gallery'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white)),
        ]),
        if (_selectedAssetImage != null || _selectedImagePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _buildSelectedImage(theme)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(imageName, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
            ]),
          ),
      ],
    );
  }

  Widget _buildSelectedImage(ThemeData theme) {
    if (_selectedAssetImage != null) return Image.asset(_selectedAssetImage!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: theme.iconTheme.color));
    if (kIsWeb && _selectedImageBytes != null) return Image.memory(_selectedImageBytes!, fit: BoxFit.cover);
    if (!kIsWeb && _selectedImagePath != null) return Image.file(File(_selectedImagePath!), fit: BoxFit.cover);
    return Icon(Icons.image, size: 40, color: theme.iconTheme.color);
  }

  // ── Category table — extracted, receives data instead of reading from context ──
  Widget _buildCategoryTable(ThemeData theme, bool isDark, List<CategoryModel> allCats, List<CategoryModel> mainCats) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: mainCats.map((category) {
          final subcategories = allCats.where((c) => c.parentId == category.id).toList();
          final isExpanded = expandedCategories.contains(category.id);
          final isDeleting = pendingDelete == category.id;

          return Column(
            key: ValueKey(category.id), // ✅ stable keys prevent unnecessary rebuilds
            children: [
              _CategoryRow(
                category: category,
                isExpanded: isExpanded,
                isDeleting: isDeleting,
                hasSubcategories: subcategories.isNotEmpty,
                isDark: isDark,
                theme: theme,
                onToggle: () => _toggleCategory(category.id),
                onEdit: () => _showCategoryForm(category: category),
                onDelete: () => _deleteCategory(category.id),
                onAddSub: () => _showSubcategoryForm(category.id),
                onConfirmDelete: () => _confirmDelete(category.id),
                onCancelDelete: _cancelDelete,
                onTap: () => _showCategoryForm(category: category),
                buildImage: () => _buildImageWidget(category, theme),
                buildStatus: () => _buildStatusBadge(category.status, theme: theme),
              ),
              if (showingSubcategoryForm == category.id)
                Container(margin: const EdgeInsets.only(left: 30, bottom: 12), child: _buildSubcategoryFormInline(category.id, theme)),
              if (isExpanded)
                ...subcategories.map((sub) => _SubcategoryRow(
                  key: ValueKey(sub.id),
                  sub: sub,
                  isDeleting: pendingDelete == sub.id,
                  isDark: isDark,
                  theme: theme,
                  parentCategory: category,
                  onEdit: () => _showCategoryForm(category: sub, parent: category),
                  onDelete: () => _deleteCategory(sub.id),
                  onConfirmDelete: () => _confirmDelete(sub.id),
                  onCancelDelete: _cancelDelete,
                  buildImage: () => _buildImageWidget(sub, theme),
                  buildStatus: () => _buildStatusBadge(sub.status, theme: theme, small: true),
                )),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageWidget(CategoryModel category, ThemeData theme) {
    Widget imageWidget;
    if (category.imagePath != null && category.imagePath!.startsWith('assets/')) {
      imageWidget = Image.asset(category.imagePath!, fit: BoxFit.cover);
    } else if (!kIsWeb && category.imagePath != null && category.imagePath!.isNotEmpty) {
      imageWidget = Image.file(File(category.imagePath!), fit: BoxFit.cover);
    } else if (category.imageUrl.isNotEmpty) {
      imageWidget = Image.network(category.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: theme.iconTheme.color, size: 25));
    } else {
      imageWidget = Icon(Icons.image, color: theme.iconTheme.color, size: 25);
    }
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(color: theme.disabledColor.withOpacity(0.2), border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(6)),
      child: ClipRRect(borderRadius: BorderRadius.circular(6), child: imageWidget),
    );
  }

  Widget _buildStatusBadge(String status, {required ThemeData theme, bool small = false}) {
    final isActive = status == 'Active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? (theme.brightness == Brightness.dark ? Colors.green.withOpacity(0.2) : const Color(0xFFD1FAE5))
            : (theme.brightness == Brightness.dark ? Colors.red.withOpacity(0.2) : const Color(0xFFFEE2E2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isActive
              ? (theme.brightness == Brightness.dark ? Colors.green.shade300 : const Color(0xFF059669))
              : (theme.brightness == Brightness.dark ? Colors.red.shade300 : const Color(0xFFDC2626)),
          fontSize: small ? 10 : 11, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSubcategoryFormInline(String parentId, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.orange.withOpacity(0.1) : Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('➕ Add Subcategory', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.textTheme.bodyMedium?.color)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildTextField(label: 'Subcategory Name', controller: _categoryNameController, theme: theme)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(label: 'Description', controller: _descriptionController, theme: theme)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildTextField(label: 'Product Count', controller: _productCountController, keyboardType: TextInputType.number, theme: theme)),
            const SizedBox(width: 2),
            Expanded(child: _statusDropdown(theme)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Radio<String>(value: 'url', groupValue: _imageSource, activeColor: Colors.green, onChanged: (v) => setState(() { _imageSource = v!; _selectedImagePath = null; _selectedAssetImage = null; _selectedImageBytes = null; })),
            Text('URL', style: theme.textTheme.bodyMedium),
            const SizedBox(width: 20),
            Radio<String>(value: 'system', groupValue: _imageSource, activeColor: Colors.green, onChanged: (v) => setState(() { _imageSource = v!; _imageUrlController.clear(); })),
            Text('System', style: theme.textTheme.bodyMedium),
          ]),
          if (_imageSource == 'url')
            _buildTextField(label: 'Image URL', controller: _imageUrlController, theme: theme)
          else
            Row(children: [
              ElevatedButton.icon(onPressed: _showAssetImagePicker, icon: const Icon(Icons.folder, size: 16), label: const Text('Assets', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
              const SizedBox(width: 8),
              ElevatedButton.icon(onPressed: _pickImageFromGallery, icon: const Icon(Icons.photo_library, size: 16), label: const Text('Gallery', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
              if (_selectedAssetImage != null || _selectedImagePath != null) ...[
                const SizedBox(width: 12),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(6)),
                  child: ClipRRect(borderRadius: BorderRadius.circular(6), child: _buildSelectedImage(theme)),
                ),
              ],
            ]),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton(onPressed: () => _saveSubcategory(parentId), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), child: const Text('Save')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: _hideSubcategoryForm, style: OutlinedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, side: const BorderSide(color: Colors.green), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), child: const Text('Cancel')),
          ]),
        ],
      ),
    );
  }
}

// ── Separate StatefulWidget for each row — prevents full list rebuild ────────
class _CategoryRow extends StatelessWidget {
  final CategoryModel category;
  final bool isExpanded, isDeleting, hasSubcategories, isDark;
  final ThemeData theme;
  final VoidCallback onToggle, onEdit, onDelete, onAddSub, onConfirmDelete, onCancelDelete, onTap;
  final Widget Function() buildImage, buildStatus;

  const _CategoryRow({
    required this.category, required this.isExpanded, required this.isDeleting,
    required this.hasSubcategories, required this.isDark, required this.theme,
    required this.onToggle, required this.onEdit, required this.onDelete,
    required this.onAddSub, required this.onConfirmDelete, required this.onCancelDelete,
    required this.onTap, required this.buildImage, required this.buildStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.cardColor, border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        buildImage(),
        const SizedBox(width: 7),
        Expanded(flex: 2, child: Row(children: [
          if (hasSubcategories)
            IconButton(icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: theme.iconTheme.color), onPressed: onToggle, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          Expanded(child: Text(category.categoryName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.textTheme.bodyMedium?.color), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ])),
        const SizedBox(width: 18),
        Expanded(flex: 2, child: Text(category.description, style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        SizedBox(width: 60, child: Text(category.productCount.toString(), style: theme.textTheme.bodyMedium)),
        const SizedBox(width: 10),
        buildStatus(),
        const SizedBox(width: 14),
        isDeleting
            ? _confirmDeleteRow(small: false)
            : _actionButtons(),
      ]),
    );
  }

  Widget _confirmDeleteRow({required bool small}) => Row(mainAxisSize: MainAxisSize.min, children: [
    Text('Confirm?', style: TextStyle(fontSize: small ? 10 : 11, color: Colors.red, fontWeight: FontWeight.w600)),
    const SizedBox(width: 8),
    ElevatedButton(onPressed: onConfirmDelete, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: const Size(0, 0), elevation: 0), child: Text('Yes', style: TextStyle(fontSize: small ? 10 : 11))),
    const SizedBox(width: 12),
    OutlinedButton(onPressed: onCancelDelete, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green, side: const BorderSide(color: Colors.green), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: const Size(0, 0)), child: Text('No', style: TextStyle(fontSize: small ? 10 : 11))),
  ]);

  Widget _actionButtons() => Wrap(spacing: 28, children: [
    ElevatedButton(onPressed: onEdit, style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.grey.shade800 : const Color(0xFFF3F4F6), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), minimumSize: const Size(0, 0), elevation: 0), child: Icon(Icons.edit, color: Colors.green, size: 20)),
    ElevatedButton(onPressed: onDelete, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), minimumSize: const Size(0, 0), elevation: 0), child: Icon(Icons.delete, color: Colors.red, size: 20)),
    ElevatedButton(
      onPressed: onAddSub,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: const Size(0, 0), elevation: 0),
      child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.add, color: Colors.white, size: 14), SizedBox(width: 4), Text('Sub', style: TextStyle(fontSize: 11, color: Colors.white))]),
    ),
  ]);
}

class _SubcategoryRow extends StatelessWidget {
  final CategoryModel sub, parentCategory;
  final bool isDeleting, isDark;
  final ThemeData theme;
  final VoidCallback onEdit, onDelete, onConfirmDelete, onCancelDelete;
  final Widget Function() buildImage, buildStatus;

  const _SubcategoryRow({
    Key? key,
    required this.sub, required this.parentCategory, required this.isDeleting,
    required this.isDark, required this.theme, required this.onEdit,
    required this.onDelete, required this.onConfirmDelete, required this.onCancelDelete,
    required this.buildImage, required this.buildStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor.withOpacity(0.5) : const Color(0xFFF9FAFB),
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        buildImage(),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: Row(children: [
          const Text('└─ ', style: TextStyle(color: Colors.orange)),
          Expanded(child: Text(sub.categoryName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: theme.textTheme.bodyMedium?.color), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ])),
        const SizedBox(width: 48),
        Expanded(flex: 2, child: Text(sub.description, style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 18),
        SizedBox(width: 60, child: Text(sub.productCount.toString(), style: theme.textTheme.bodyMedium)),
        const SizedBox(width: 8),
        buildStatus(),
        const SizedBox(width: 8),
        Flexible(child: isDeleting ? _deleteConfirm() : _actionButtons()),
      ]),
    );
  }

  Widget _deleteConfirm() => Row(mainAxisSize: MainAxisSize.min, children: [
    const Text('Delete?', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w600)),
    const SizedBox(width: 14),
    ElevatedButton(onPressed: onConfirmDelete, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: const Size(0, 0), elevation: 0, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Text('Yes', style: TextStyle(fontSize: 10))),
    const SizedBox(width: 12),
    OutlinedButton(onPressed: onCancelDelete, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green, side: const BorderSide(color: Colors.green), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Text('No', style: TextStyle(fontSize: 10))),
  ]);

  Widget _actionButtons() => Row(mainAxisSize: MainAxisSize.min, children: [
    const SizedBox(width: 30),
    ElevatedButton(onPressed: onEdit, style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.grey.shade800 : const Color(0xFFF3F4F6), foregroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), minimumSize: const Size(8, 14), elevation: 0, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: Icon(Icons.edit, color: Colors.green, size: 20)),
    const SizedBox(width: 8),
    ElevatedButton(onPressed: onDelete, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), minimumSize: const Size(0, 0), elevation: 0, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: Icon(Icons.delete, color: Colors.red, size: 20)),
  ]);
}

// ── Stats data class for Selector ────────────────────────────────────────────
class _StatsData {
  final int total, products, active, inactive;
  const _StatsData(this.total, this.products, this.active, this.inactive);
  @override bool operator ==(Object other) => other is _StatsData && total == other.total && products == other.products && active == other.active && inactive == other.inactive;
  @override int get hashCode => Object.hash(total, products, active, inactive);
}