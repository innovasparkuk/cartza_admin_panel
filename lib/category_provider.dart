import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _loading = false;

  List<CategoryModel> get categories => _categories;
  bool get loading => _loading;

  List<CategoryModel> get mainCategories =>
      _categories.where((c) => c.parentId.isEmpty).toList();

  int get totalProducts =>
      _categories.fold(0, (sum, c) => sum + c.productCount);

  int get activeCategoriesCount =>
      mainCategories.where((c) => c.status == 'Active').length;

  int get inactiveCategoriesCount =>
      mainCategories.where((c) => c.status == 'Inactive').length;

  Future<void> loadCategories() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await ApiService.getCategories();
      _categories = data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Load error: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel category) async {
    await ApiService.addCategory(category.toJson());
    await loadCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await ApiService.updateCategory(category.id, category.toJson());
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await ApiService.deleteCategory(id);
    await loadCategories();
  }
}
