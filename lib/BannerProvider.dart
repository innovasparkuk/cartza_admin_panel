import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BannerModel {
  final String id;
  String title;
  String imageUrl;
  bool active;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.active,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      active: json['active'] ?? false,
    );
  }
}

class BannerProvider with ChangeNotifier {
  bool isLoading = false;
  List<BannerModel> banners = [];

  Future<void> loadBanners() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getBanners();
      banners = data.map((e) => BannerModel.fromJson(e)).toList();
    } catch (e) {
      banners = [];
      debugPrint('Error loading banners: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addBanner(String title, String imageUrl, bool active, BuildContext context) async {
    try {
      final res = await ApiService.addBanner(title, imageUrl, active);
      banners.add(BannerModel.fromJson(res['banner']));
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner added')),
      );
    } catch (e) {
      debugPrint('Error adding banner: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add banner')),
      );
    }
  }

  Future<void> updateBanner(String id, String title, String imageUrl, bool active, BuildContext context) async {
    try {
      await ApiService.updateBanner(id, title, imageUrl, active);

      final index = banners.indexWhere((b) => b.id == id);
      if (index != -1) {
        banners[index].title = title;
        banners[index].imageUrl = imageUrl;
        banners[index].active = active;
        notifyListeners();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner updated')),
      );
    } catch (e) {
      debugPrint('Error updating banner: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update banner')),
      );
    }
  }

  Future<void> deleteBanner(String id, BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Banner'),
        content: const Text('Are you sure you want to delete this banner?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      banners.removeWhere((b) => b.id == id);
      notifyListeners();
      await ApiService.deleteBanner(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner deleted')),
      );
    } catch (e) {
      debugPrint('Error deleting banner: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete banner')),
      );
    }
  }
}
