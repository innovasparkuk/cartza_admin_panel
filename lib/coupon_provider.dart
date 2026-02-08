import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../promotions/coupons/coupon_model.dart';

class CouponProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Coupon> coupons = [];

  Future<void> loadCoupons() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiService.getCoupons();
    coupons = data.map((e) => Coupon.fromJson(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addCoupon(Coupon c) async {
    await ApiService.addCoupon(c.toJson());
    await loadCoupons();
  }

  Future<void> updateCoupon(Coupon c) async {
    await ApiService.updateCoupon(c.id!, c.toJson());
    await loadCoupons();
  }

  Future<void> deleteCoupon(String id) async {
    await ApiService.deleteCoupon(id);
    await loadCoupons();
  }
}
