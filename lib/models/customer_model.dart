class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  CustomerStatus status;
  final int totalOrders;
  final DateTime joinDate;
  final DateTime lastActive;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.totalOrders,
    required this.joinDate,
    required this.lastActive,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: CustomerStatus.fromString(json['status'] ?? 'active'),
      totalOrders: json['totalOrders'] ?? 0,
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : DateTime.now(),
      address: json['address'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status.value,
      'totalOrders': totalOrders,
      'joinDate': joinDate.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      if (address != null) 'address': address,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  String get customerAge {
    final now = DateTime.now();
    final difference = now.difference(joinDate);

    if (difference.inDays < 30) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
  }

  String get lastActiveDuration {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hrs ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    CustomerStatus? status,
    int? totalOrders,
    DateTime? joinDate,
    DateTime? lastActive,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      totalOrders: totalOrders ?? this.totalOrders,
      joinDate: joinDate ?? this.joinDate,
      lastActive: lastActive ?? this.lastActive,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isNewCustomer {
    final difference = DateTime.now().difference(joinDate);
    return difference.inDays <= 30;
  }

  bool get isRecentlyActive {
    final difference = DateTime.now().difference(lastActive);
    return difference.inHours <= 24;
  }
}

enum CustomerStatus {
  active('Active'),
  inactive('Inactive'),
  blocked('Blocked');

  final String value;
  const CustomerStatus(this.value);

  static CustomerStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return CustomerStatus.active;
      case 'inactive':
        return CustomerStatus.inactive;
      case 'blocked':
        return CustomerStatus.blocked;
      default:
        return CustomerStatus.active;
    }
  }

  String get label => value;
}