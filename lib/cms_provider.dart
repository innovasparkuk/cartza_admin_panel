import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CmsPageModel {
  final String id;
  String title;
  String content;

  CmsPageModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory CmsPageModel.fromJson(Map<String, dynamic> json) {
    return CmsPageModel(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
    );
  }
}
class CmsProvider with ChangeNotifier {
  bool isLoading = false;
  List<CmsPageModel> pages = [];

  // LOAD
  Future<void> loadPages() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiService.getCmsPages();
    pages = data.map((e) => CmsPageModel.fromJson(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  // ADD
  Future<void> addPage(
      String title,
      String content,
      BuildContext context,
      ) async {
    final res = await ApiService.addCmsPage(title, content);
    pages.add(CmsPageModel.fromJson(res['page']));
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page added')),
    );
  }

  // UPDATE
  Future<void> updatePage(
      String id,
      String title,
      String content,
      BuildContext context,
      ) async {
    await ApiService.updateCmsPage(id, title, content);

    final index = pages.indexWhere((p) => p.id == id);
    if (index != -1) {
      pages[index].title = title;
      pages[index].content = content;
      notifyListeners();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page updated')),
    );
  }

  // DELETE
  Future<void> deletePage(String id, BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Page'),
        content: const Text('Are you sure you want to delete this page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    pages.removeWhere((p) => p.id == id);
    notifyListeners();
    await ApiService.deleteCmsPage(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page deleted')),
    );
  }
}
