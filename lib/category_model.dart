class CategoryModel {
  final String id;
  final String categoryName;
  final String description;
  final int productCount;
  final String status;
  final String parentId;
  final int subcategoryCount;
  final DateTime createdAt;
  final String imageUrl;
  final String? imagePath;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.productCount,
    required this.status,
    required this.parentId,
    required this.subcategoryCount,
    required this.createdAt,
    required this.imageUrl,
    this.imagePath,
  });

  // 🔁 copyWith (edit/update ke liye)
  CategoryModel copyWith({
    String? id,
    String? categoryName,
    String? description,
    int? productCount,
    String? status,
    String? parentId,
    int? subcategoryCount,
    DateTime? createdAt,
    String? imageUrl,
    String? imagePath,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      productCount: productCount ?? this.productCount,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
      subcategoryCount: subcategoryCount ?? this.subcategoryCount,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // 📥 MongoDB se data lene ke liye
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? json['id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      productCount: json['productCount'] ?? 0,
      status: json['status'] ?? 'Active',
      parentId: json['parentId'] ?? '',
      subcategoryCount: json['subcategoryCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      imageUrl: json['imageUrl'] ?? '',
      imagePath: json['imagePath'],
    );
  }

  // 📤 MongoDB ko data bhejne ke liye
  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'description': description,
      'productCount': productCount,
      'status': status,
      'parentId': parentId,
      'subcategoryCount': subcategoryCount,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
