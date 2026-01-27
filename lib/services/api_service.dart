import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

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
