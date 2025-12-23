import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:untitled/categories_page.dart';

void main() {
  runApp( CartzaAdminApp());
}

class CartzaAdminApp extends StatelessWidget {
  CartzaAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartza Admin',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  String selectedMenu = 'Dashboard';
  String selectedChartPeriod = 'Week';

  late AnimationController _taglineController;

  // Dashboard Stats
  int totalUsers = 24856;
  double userGrowth = 12.5;
  int totalOrders = 3486;
  double orderGrowth = 8.3;
  double revenueToday = 89420;
  double revenueGrowth = 23.1;
  int activeProducts = 1248;
  double productGrowth = -2.4;

  // Chart data for weekly sales
  final List<double> weeklySales = [300, 420, 380, 550, 480, 680, 520];
  final List<double> monthlySales = [12000, 15000, 13500, 18000, 16500, 21000, 19500, 23000];
  final List<double> yearlySales = [150000, 180000, 165000, 210000, 195000, 240000, 225000, 270000, 255000, 290000, 275000, 310000];

  // Recent orders data
  final List<Map<String, dynamic>> recentOrders = [
    {'id': '#ORD-2024-001', 'customer': 'John Doe', 'product': 'Wireless Headphones', 'amount': '\$129.99', 'status': 'Delivered', 'date': '2024-12-05'},
    {'id': '#ORD-2024-002', 'customer': 'Sarah Smith', 'product': 'Smart Watch', 'amount': '\$299.99', 'status': 'Processing', 'date': '2024-12-05'},
    {'id': '#ORD-2024-003', 'customer': 'Mike Johnson', 'product': 'Laptop Stand', 'amount': '\$49.99', 'status': 'Shipped', 'date': '2024-12-04'},
    {'id': '#ORD-2024-004', 'customer': 'Emily Brown', 'product': 'USB-C Cable', 'amount': '\$19.99', 'status': 'Delivered', 'date': '2024-12-04'},
    {'id': '#ORD-2024-005', 'customer': 'David Wilson', 'product': 'Phone Case', 'amount': '\$24.99', 'status': 'Pending', 'date': '2024-12-03'},
  ];

  @override
  void initState() {
    super.initState();
    // Setup for tagline fade animation
    _taglineController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.8, end: 1.0),
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logo1.png',
                                  width: 110,
                                  height: 75,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 5),
                        // Animated Tagline
                        Center(
                          child: AnimatedOpacity(
                            opacity: _taglineController.value,
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              'Shop Smarter, Live Better',
                              style: TextStyle(
                                color: Colors.orange, // Changed color to orange for visibility
                                fontSize: 14, // Slightly increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.green),
                  // Logo and Brand with animation - END

                  // Main Menu (Removed the 'MAIN' section header for a cleaner look)
                  _buildMenuCard(Icons.dashboard, 'Dashboard'),
                  _buildMenuCard(Icons.shopping_bag, 'Orders'),
                  _buildMenuCard(Icons.inventory, 'Products'),
                  _buildMenuCard(Icons.category, 'Categories', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CategoriesPage()),
                    );
                  }),



                  _buildMenuCard(Icons.people, 'Customers'),
                  _buildMenuCard(Icons.payment, 'Payments'),
                  _buildMenuCard(Icons.local_offer, 'Promotions'),
                  _buildMenuCard(Icons.star, 'Reviews'),

                  _buildMenuCard(Icons.analytics, 'Analytics'),
                  _buildMenuCard(Icons.settings, 'Settings'),

                ],
              ),
            ),
          ),


          // Main Content
          Expanded(
            child: Column(
              children: [
              // Header
              Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search orders, products, customers...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.mail_outline, size: 28),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: const Text('A', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

            // Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back, Admin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Here's what's happening with your store today",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            Icons.people,
                            totalUsers.toString(),
                            'Total Users',
                            userGrowth,
                            Colors.purple.shade100,
                            Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildStatCard(
                            Icons.shopping_bag,
                            totalOrders.toString(),
                            'Total Orders',
                            orderGrowth,
                            Colors.orange.shade100,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildStatCard(
                            Icons.attach_money,
                            revenueToday.toStringAsFixed(0),
                            'Revenue Today',
                            revenueGrowth,
                            Colors.green.shade100,
                            Colors.green,
                          ),
                        ),


                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildStatCard(
                            Icons.inventory,
                            activeProducts.toString(),
                            'Active Products',
                            productGrowth,
                            Colors.blue.shade100,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Sales Overview and Top Categories
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildSalesOverview(),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTopCategories(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Recent Orders
                    _buildRecentOrders(),
                  ],
                ),
              ),
            ),
            ],
          ),
          ),
      ],
      ),
    );
  }


  Widget _buildMenuSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey, // Adjusted color to be more subtle/non-white for white background
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    final isSelected = selectedMenu == title;
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMenuCard(IconData icon, String title, {VoidCallback? onTap}) {
    final bool isSelected = selectedMenu == title;

    return InkWell(
      onTap: onTap ?? () {
        setState(() {
          selectedMenu = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),

          // ✅ Glow animation on selected
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.green.withOpacity(0.6),
              blurRadius: 14,
              spreadRadius: 3,
            ),
          ]
              : [],
        ),

        child: Row(
          children: [
            // ✅ Animated icon
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(width: 12),

            // ✅ Animated text color
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatCard(
      IconData icon,
      String value,
      String label,
      double growth,
      Color bgColor,
      Color iconColor,
      ) {
    final isPositive = growth >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${growth.abs()}%',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesOverview() {
    List<double> currentData = selectedChartPeriod == 'Week'
        ? weeklySales
        : selectedChartPeriod == 'Month'
        ? monthlySales
        : yearlySales;

    return Container(
      padding:  EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sales Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildPeriodButton('Week'),
                  const SizedBox(width: 5),
                  _buildPeriodButton('Month'),
                  const SizedBox(width: 5),
                  _buildPeriodButton('Year'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: currentData.reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.white, // ✅ Background white
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toStringAsFixed(0),
                        const TextStyle(
                          color: Colors.green, // ✅ Text green
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          (value.toInt() + 1).toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  currentData.length,
                      (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: currentData[index],
                        color: Colors.green,
                        width: 30,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedChartPeriod == period;
    return InkWell(
      onTap: () {
        setState(() {
          selectedChartPeriod = period;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTopCategories() {
    final categories = [
      {'name': 'Fashion', 'items': '1,245 items', 'value': '\$24.5K', 'icon': Icons.checkroom, 'color': Colors.blue},
      {'name': 'Electronics', 'items': '856 items', 'value': '\$18.2K', 'icon': Icons.phone_android, 'color': Colors.purple},
      {'name': 'Home & Living', 'items': '642 items', 'value': '\$12.8K', 'icon': Icons.home, 'color': Colors.orange},
      {'name': 'Beauty', 'items': '524 items', 'value': '\$9.4K', 'icon': Icons.face, 'color': Colors.pink},
    ];

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...categories.map((cat) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: cat['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        cat['items'] as String,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  cat['value'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.orange),
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
              columns: const [
                DataColumn(label: Text('ORDER ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              ],
              rows: recentOrders.map((order) {
                return DataRow(
                  cells: [
                    DataCell(Text(order['id'], style: const TextStyle(fontSize: 13))),
                    DataCell(Text(order['customer'], style: const TextStyle(fontSize: 13))),
                    DataCell(Text(order['product'], style: const TextStyle(fontSize: 13))),
                    DataCell(Text(order['amount'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            color: _getStatusColor(order['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(order['date'], style: const TextStyle(fontSize: 13))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.orange;
      case 'Pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
