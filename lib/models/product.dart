class Product {
  String id;
  String name;
  String description;
  double price;
  String category;
  int stockQuantity;
  int lowStockThreshold;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> tags;
  Map<String, dynamic>? attributes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    this.lowStockThreshold = 10,
    this.imageUrl = '',
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? 'No description',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? 'General',
      stockQuantity: json['stockQuantity'] ?? 0,
      lowStockThreshold: json['lowStockThreshold'] ?? 10,
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      tags: List<String>.from(json['tags'] ?? []),
      attributes: json['attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'imageUrl': imageUrl,
      'tags': tags,
      'attributes': attributes,
    };
  }
}
