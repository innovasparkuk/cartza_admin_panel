class SalesData {
  final String label;
  final int value;
  final String? category;
  final double percentageChange;

  SalesData(this.label, this.value, {this.category, this.percentageChange = 0.0});

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      json['label'],
      json['value'],
      category: json['category'],
      percentageChange: json['percentageChange'] ?? 0.0,
    );
  }

 static List<SalesData> getWeeklySales() {
    return [
      SalesData('Mon', 42000),
      SalesData('Tue', 38000),
      SalesData('Wed', 55000),
      SalesData('Thu', 72000),
      SalesData('Fri', 68000),
      SalesData('Sat', 85000),
      SalesData('Sun', 92000),
    ];
  }

  static List<SalesData> getCategorySales() {
    return [
      SalesData('Electronics', 42, category: 'Sales', percentageChange: 12.5),
      SalesData('Fashion', 38, category: 'Sales', percentageChange: 8.2),
      SalesData('Home', 28, category: 'Sales', percentageChange: 15.3),
      SalesData('Books', 19, category: 'Sales', percentageChange: 5.7),
      SalesData('Sports', 15, category: 'Sales', percentageChange: 22.1),
    ];
  }

  static List<SalesData> getMonthlyRevenue() {
    return [
      SalesData('Jan', 125000),
      SalesData('Feb', 142000),
      SalesData('Mar', 168000),
      SalesData('Apr', 192000),
      SalesData('May', 215000),
      SalesData('Jun', 238000),
      SalesData('Jul', 256000),
      SalesData('Aug', 278000),
      SalesData('Sep', 291000),
      SalesData('Oct', 312000),
      SalesData('Nov', 298000),
      SalesData('Dec', 325000),
    ];
  }
}