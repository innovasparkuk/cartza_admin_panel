class Coupon {
  String? id;
  String code;
  String type;
  int value;
  DateTime expiryDate;
  bool isActive;

  Coupon({
    this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.expiryDate,
    this.isActive = true,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['_id'],
      code: json['code'],
      type: json['type'],
      value: json['value'],
      expiryDate: DateTime.parse(json['expiryDate']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'value': value,
      'expiryDate': expiryDate.toIso8601String(),
      'isActive': isActive,
    };
  }
}
