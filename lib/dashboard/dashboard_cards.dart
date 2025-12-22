import 'package:flutter/material.dart';

class DashboardCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard(
          context: context,
          icon: Icons.people,
          title: "Total Users",
          value: "1,234",
          color: Color(0xFF212121),
          bgColor: Color(0xFF212121).withOpacity(0.1),
          onTap: () {
            print("Users card clicked");
           },
        ),

        SizedBox(width: 16),

        _buildCard(
          context: context,
          icon: Icons.shopping_cart,
          title: "Total Orders",
          value: "567",
          color: Color(0xFFFF6F00),
          bgColor: Color(0xFFFF6F00).withOpacity(0.1),
          onTap: () {
            print("Orders card clicked");
          },
        ),

        SizedBox(width: 16),

        _buildCard(
          context: context,
          icon: Icons.currency_rupee,
          title: "Total Revenue",
          value: "₹89,000",
          color: Color(0xFF4CAF50),
          bgColor: Color(0xFF4CAF50).withOpacity(0.1),
          onTap: () {
            print("Revenue card clicked");
          },
        ),

        SizedBox(width: 16),

        _buildCard(
          context: context,
          icon: Icons.inventory,
          title: "Active Products",
          value: "1,089",
          color: Colors.purple,
          bgColor: Colors.purple.withOpacity(0.1),
          onTap: () {
            print("Products card clicked");
          },
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    Color? bgColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor ?? color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: color),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
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
