class FlashSale {
  String title;
  int discount;
  String startTime;
  String endTime;
  bool active;

  FlashSale({
    required this.title,
    required this.discount,
    required this.startTime,
    required this.endTime,
    this.active = true,
  });
}
