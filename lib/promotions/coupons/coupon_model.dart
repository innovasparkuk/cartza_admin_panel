class Coupon {
  String code;
  String type;
  int value;
  DateTime expiryDate;
  bool isActive;

  Coupon({
    required this.code,
    required this.type,
    required this.value,
    required this.expiryDate,
    this.isActive = true,
  });
}
