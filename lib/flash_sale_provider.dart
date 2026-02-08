import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../promotions/coupons/coupon_model.dart';
import '../promotions/flash_sales/flash_sale_model.dart';

class FlashSaleProvider extends ChangeNotifier {
  bool isLoading = false;
  List<FlashSale> flashSales = [];

  Future<void> loadFlashSales() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiService.getFlashSales();
    flashSales = data.map((e) => FlashSale.fromJson(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addFlashSale(FlashSale sale) async {
    await ApiService.addFlashSale(sale.toJson());
    await loadFlashSales();
  }

  Future<void> updateFlashSale(FlashSale sale) async {
    await ApiService.updateFlashSale(sale.id!, sale.toJson());
    await loadFlashSales();
  }

  Future<void> deleteFlashSale(String id) async {
    await ApiService.deleteFlashSale(id);
    await loadFlashSales();
  }
}
