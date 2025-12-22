import 'package:flutter/material.dart';
import 'dashboard_cards.dart';
import 'dashboard_charts.dart';
import 'sidebar.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedMenuIndex = 0;
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E6E6),

      body: Row(
        children: [
          if (!_sidebarCollapsed) SidebarMenu(
            onMenuSelected: (index) {
              setState(() {
                _selectedMenuIndex = index;
              });
            },
            selectedIndex: _selectedMenuIndex,
          ),

          Expanded(
            child: Container(
              color: Color(0xFFF5F5F5),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_selectedMenuIndex) {
      case 0:
        return "Dashboard Overview";
      case 1:
        return "Product Management";
      case 2:
        return "Order Management";
      case 3:
        return "Customer Management";
      case 4:
        return "Payment Transactions";
      case 5:
        return "Promotions & Coupons";
      case 6:
        return "Reviews & Ratings";
      case 7:
        return "Reports & Analytics";
      case 8:
        return "CMS Management";
      case 9:
        return "System Settings";
      default:
        return "ShopEase Admin";
    }
  }

  Widget _buildContent() {
    if (_selectedMenuIndex != 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.dashboard,
            //   size: 80,
            //   color: Color(0xFF212121).withOpacity(0.1),
            // ),
            // SizedBox(height: 20),
            // Text(
            //   _getTitle(),
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF212121),
            //   ),
            // ),
            // SizedBox(height: 10),
            // Text(
            //   "This section is under development",
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.grey[600],
            //   ),
            // ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          DashboardCards(),
          SizedBox(height: 30),

          DashboardCharts(),
          SizedBox(height: 30),
        ],
      ),
    );
  }


  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 180,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                SizedBox(height: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Click to open",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}