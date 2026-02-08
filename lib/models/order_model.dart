class OrderProduct {
  final String name;
  final int qty;
  final double price;

  OrderProduct({
    required this.name,
    required this.qty,
    required this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'price': price,
    };
  }

  double get total => price * qty;
}

class Order {
  final String id;
  final String orderId;
  final String customer;
  final String? customerId;
  final String email;
  final String phone;
  final List<OrderProduct> products;
  final double totalAmount;
  final OrderStatus status;
  final DateTime date;
  final String address;
  final PaymentMethod paymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.orderId,
    required this.customer,
    this.customerId,
    required this.email,
    required this.phone,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.address,
    required this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      customer: json['customer'] ?? '',
      customerId: json['customerId'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((p) => OrderProduct.fromJson(p))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.fromString(json['status'] ?? 'Pending'),
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      address: json['address'] ?? '',
      paymentMethod: PaymentMethod.fromString(json['paymentMethod'] ?? 'Cash on Delivery'),
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
      'orderId': orderId,
      'customer': customer,
      'customerId': customerId,
      'email': email,
      'phone': phone,
      'products': products.map((p) => p.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.value,
      'date': date.toIso8601String(),
      'address': address,
      'paymentMethod': paymentMethod.value,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  String get orderAge {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  int get totalItems {
    return products.fold(0, (sum, product) => sum + product.qty);
  }

  Order copyWith({
    String? id,
    String? orderId,
    String? customer,
    String? customerId,
    String? email,
    String? phone,
    List<OrderProduct>? products,
    double? totalAmount,
    OrderStatus? status,
    DateTime? date,
    String? address,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customer: customer ?? this.customer,
      customerId: customerId ?? this.customerId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      products: products ?? this.products,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      date: date ?? this.date,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum OrderStatus {
  pending('Pending'),
  processing('Processing'),
  shipped('Shipped'),
  delivered('Delivered'),
  cancelled('Cancelled');

  final String value;
  const OrderStatus(this.value);

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String get label => value;
}

enum PaymentMethod {
  creditCard('Credit Card'),
  debitCard('Debit Card'),
  cashOnDelivery('Cash on Delivery'),
  paypal('PayPal'),
  bankTransfer('Bank Transfer');

  final String value;
  const PaymentMethod(this.value);

  static PaymentMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
        return PaymentMethod.creditCard;
      case 'debit card':
        return PaymentMethod.debitCard;
      case 'cash on delivery':
        return PaymentMethod.cashOnDelivery;
      case 'paypal':
        return PaymentMethod.paypal;
      case 'bank transfer':
        return PaymentMethod.bankTransfer;
      default:
        return PaymentMethod.cashOnDelivery;
    }
  }

  String get label => value;
}