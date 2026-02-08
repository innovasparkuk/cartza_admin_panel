import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // ================= IMAGE UPLOAD (WEB) =================

  static Future<String> uploadImageBytes(Uint8List bytes) async {
    final uri = Uri.parse('$baseUrl/api/products/upload-image');

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: 'product.png',
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Image upload failed');
    }

    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);
    return data['imageUrl'];
  }

  // ================= CATEGORY IMAGE UPLOAD =================

  // For Mobile/Desktop (uses file path)
  static Future<String> uploadCategoryImage(String imagePath) async {
    final uri = Uri.parse('$baseUrl/api/categories/upload-image');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Category image upload failed');
    }

    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);
    return data['imageUrl'];
  }

  static Future<String> uploadCategoryImageBytes(Uint8List bytes, String filename) async {
    final uri = Uri.parse('$baseUrl/api/categories/upload-image');
    final request = http.MultipartRequest('POST', uri);

    // ✅ Ensure filename has extension
    String finalFilename = filename;
    if (!filename.contains('.')) {
      finalFilename = 'category_${DateTime.now().millisecondsSinceEpoch}.png';
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: finalFilename,
        contentType: MediaType('image', 'png'), // ✅ ADD THIS
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();
      throw Exception('Image upload failed: $errorBody');
    }

    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);
    return data['imageUrl'];
  }

  // ================= PRODUCT STOCK =================

  static Future<void> updateProductStock(String id, int stock) async {
    await http.put(
      Uri.parse('$baseUrl/api/products/$id/stock'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'stockQuantity': stock}),
    );
  }

  // ================= CORE REQUEST =================

  static Future<Map<String, dynamic>> _makeRequest({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl/api/$endpoint');
    final headers = {'Content-Type': 'application/json'};

    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception('Invalid method');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }
  // ================= ORDERS =================

  static Future<List<dynamic>> getOrders() async {
    final response = await _makeRequest(endpoint: 'orders');
    if (response['success'] == true) {
      return response['orders'] ?? [];
    }
    return [];
  }

  static Future<Map<String, dynamic>> getOrder(String id) async {
    return await _makeRequest(endpoint: 'orders/$id');
  }

  static Future<Map<String, dynamic>> addOrder(Map<String, dynamic> order) async {
    return await _makeRequest(
      endpoint: 'orders',
      method: 'POST',
      body: order,
    );
  }

  static Future<Map<String, dynamic>> updateOrder(
      String id, Map<String, dynamic> data) async {
    return await _makeRequest(
      endpoint: 'orders/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<Map<String, dynamic>> updateOrderStatus(
      String id, String status) async {
    return await _makeRequest(
      endpoint: 'orders/$id/status',
      method: 'PUT',
      body: {'status': status},
    );
  }

  static Future<Map<String, dynamic>> deleteOrder(String id) async {
    return await _makeRequest(
      endpoint: 'orders/$id',
      method: 'DELETE',
    );
  }

  static Future<List<dynamic>> getOrdersByStatus(String status) async {
    final response = await _makeRequest(endpoint: 'orders/status/$status');
    if (response['success'] == true) {
      return response['orders'] ?? [];
    }
    return [];
  }

  static Future<List<dynamic>> getOrdersByCustomer(String customerId) async {
    final response = await _makeRequest(endpoint: 'orders/customer/$customerId');
    if (response['success'] == true) {
      return response['orders'] ?? [];
    }
    return [];
  }

  static Future<Map<String, dynamic>> getOrderStats() async {
    final response = await _makeRequest(endpoint: 'orders/stats/overview');
    if (response['success'] == true) {
      return response['stats'] ?? {};
    }
    return {};
  }

  // ================= CUSTOMERS =================

  static Future<List<dynamic>> getCustomers() async {
    final res = await _makeRequest(endpoint: 'customers');
    return res['customers'] ?? [];
  }

  static Future<Map<String, dynamic>> getCustomer(String id) async {
    return await _makeRequest(endpoint: 'customers/$id');
  }

  static Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> customer) async {
    return await _makeRequest(
      endpoint: 'customers',
      method: 'POST',
      body: customer,
    );
  }

  static Future<Map<String, dynamic>> updateCustomer(
      String id, Map<String, dynamic> data) async {
    return await _makeRequest(
      endpoint: 'customers/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<void> updateCustomerStatus(String id, String status) async {
    await _makeRequest(
      endpoint: 'customers/$id/status',
      method: 'PUT',
      body: {'status': status},
    );
  }

  static Future<Map<String, dynamic>> deleteCustomer(String id) async {
    return await _makeRequest(
      endpoint: 'customers/$id',
      method: 'DELETE',
    );
  }

  static Future<Map<String, dynamic>> getCustomerStats() async {
    final response = await _makeRequest(endpoint: 'customers/stats/overview');
    if (response['success'] == true) {
      return response['stats'] ?? {};
    }
    return {};
  }

  // ================= ANALYTICS =================

  static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/analytics'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['analytics'] ?? {};
      }
      throw Exception('Failed to load analytics');
    } catch (e) {
      print('Analytics error: $e');
      return {};
    }
  }

  static Future<Map<String, dynamic>> getAnalyticsByRange(String range) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/analytics/range/$range'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['analytics'] ?? {};
      }
      throw Exception('Failed to load analytics for range $range');
    } catch (e) {
      print('Analytics range error: $e');
      return {};
    }
  }

  static Future<void> saveAnalytics(Map<String, dynamic> analyticsData) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/analytics'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(analyticsData),
      );
    } catch (e) {
      print('Save analytics error: $e');
    }
  }

  static Future<void> addTransaction(Map<String, dynamic> transaction) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/analytics/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'transaction': transaction}),
      );
    } catch (e) {
      print('Add transaction error: $e');
    }
  }

  static Future<void> updateTransactionStatus(String id, String status) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/api/analytics/transactions/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
    } catch (e) {
      print('Update transaction error: $e');
    }
  }

  static Future<void> addUser(Map<String, dynamic> user) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/analytics/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': user}),
      );
    } catch (e) {
      print('Add user error: $e');
    }
  }

  static Future<void> generateReport(Map<String, dynamic> report) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/analytics/reports'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'report': report}),
      );
    } catch (e) {
      print('Generate report error: $e');
    }
  }

  // ================= PRODUCTS =================

  static Future<List<dynamic>> getProducts() async {
    final response = await _makeRequest(endpoint: 'products');
    if (response['success'] == true) {
      return response['products'] ?? [];
    }
    return [];
  }

  static Future<Map<String, dynamic>> addProduct(
      Map<String, dynamic> product) async {
    return await _makeRequest(
      endpoint: 'products',
      method: 'POST',
      body: product,
    );
  }
  // ================= COUPONS =================

  static Future<List<dynamic>> getCoupons() async {
    final res = await _makeRequest(endpoint: 'coupons');
    return res['coupons'] ?? [];
  }

  static Future<void> addCoupon(Map<String, dynamic> data) async {
    await _makeRequest(
      endpoint: 'coupons',
      method: 'POST',
      body: data,
    );
  }

  static Future<void> updateCoupon(String id, Map<String, dynamic> data) async {
    await _makeRequest(
      endpoint: 'coupons/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<void> deleteCoupon(String id) async {
    await _makeRequest(
      endpoint: 'coupons/$id',
      method: 'DELETE',
    );
  }

  // ================= CMS =================
  static Future<List<dynamic>> getCmsPages() async {
    final response = await _makeRequest(endpoint: 'cms-pages');
    return response['pages'] ?? [];
  }

  static Future<Map<String, dynamic>> addCmsPage(
      String title,
      String content,
      ) async {
    return await _makeRequest(
      endpoint: 'cms-pages',
      method: 'POST',
      body: {
        'title': title,
        'content': content,
      },
    );
  }

  static Future<void> updateCmsPage(
      String id,
      String title,
      String content,
      ) async {
    await _makeRequest(
      endpoint: 'cms-pages/$id',
      method: 'PUT',
      body: {
        'title': title,
        'content': content,
      },
    );
  }


  static Future<void> deleteCmsPage(String id) async {
    await _makeRequest(
      endpoint: 'cms-pages/$id',
      method: 'DELETE',
    );
  }



  static Future<Map<String, dynamic>> updateProduct(
      String id, Map<String, dynamic> data) async {
    return await _makeRequest(
      endpoint: 'products/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<Map<String, dynamic>> deleteProduct(String id) async {
    return await _makeRequest(
      endpoint: 'products/$id',
      method: 'DELETE',
    );
  }
  // ================= FLASH SALES =================

  static Future<List<dynamic>> getFlashSales() async {
    final res = await _makeRequest(endpoint: 'flash-sales');
    return res['flashSales'] ?? [];
  }

  static Future<void> addFlashSale(Map<String, dynamic> data) async {
    await _makeRequest(
      endpoint: 'flash-sales',
      method: 'POST',
      body: data,
    );
  }

  static Future<void> updateFlashSale(String id, Map<String, dynamic> data) async {
    await _makeRequest(
      endpoint: 'flash-sales/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<void> deleteFlashSale(String id) async {
    await _makeRequest(
      endpoint: 'flash-sales/$id',
      method: 'DELETE',
    );
  }
// ================= CATEGORIES =================

  static Future<List<dynamic>> getCategories() async {
    final response = await _makeRequest(endpoint: 'categories');
    return response?['categories'] ?? [];
  }

  static Future<void> addCategory(Map<String, dynamic> data) async {
    await _makeRequest(
      endpoint: 'categories',
      method: 'POST',
      body: data,
    );
  }

  static Future<void> updateCategory(
      String id, Map<String, dynamic> data) async {
    await _makeRequest(
      endpoint: 'categories/$id',
      method: 'PUT',
      body: data,
    );
  }

  static Future<void> deleteCategory(String id) async {
    await _makeRequest(
      endpoint: 'categories/$id',
      method: 'DELETE',
    );
  }

// ================= BANNERS =================
  static Future<List<dynamic>> getBanners() async {
    final response = await _makeRequest(endpoint: 'banners');
    return response['banners'] ?? [];
  }

  static Future<Map<String, dynamic>> addBanner(String title, String imageUrl, bool active) async {
    return await _makeRequest(endpoint: 'banners', method: 'POST', body: {
      'title': title,
      'imageUrl': imageUrl,
      'active': active,
    });
  }

  static Future<Map<String, dynamic>> updateBanner(String id, String title, String imageUrl, bool active) async {
    return await _makeRequest(endpoint: 'banners/$id', method: 'PUT', body: {
      'title': title,
      'imageUrl': imageUrl,
      'active': active,
    });
  }

  static Future<void> deleteBanner(String id) async {
    await _makeRequest(endpoint: 'banners/$id', method: 'DELETE');
  }
  // ================= UTILS =================

  static Future<Map<String, dynamic>> testConnection() async {
    return await _makeRequest(endpoint: 'test-db');
  }

  static Future<bool> isServerRunning() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}