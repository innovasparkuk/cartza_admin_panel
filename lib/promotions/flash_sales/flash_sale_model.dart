class FlashSale {
  String? id;
  String title;
  int discount;
  String startTime;
  String endTime;
  bool active;

  FlashSale({
    this.id,
    required this.title,
    required this.discount,
    required this.startTime,
    required this.endTime,
    this.active = true,
  });

  factory FlashSale.fromJson(Map<String, dynamic> json) {
    return FlashSale(
      id: json['_id'],
      title: json['title'],
      discount: json['discount'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'discount': discount,
      'startTime': startTime,
      'endTime': endTime,
      'active': active,
    };
  }
}
