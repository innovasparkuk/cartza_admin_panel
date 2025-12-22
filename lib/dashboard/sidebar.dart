import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final Function(int) onMenuSelected;
  final int selectedIndex;

  const SidebarMenu({
    Key? key,
    required this.onMenuSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CAF50);
    const darkGreen = Color(0xFF388E3C);
    const lightGreen = Color(0xFFE8F5E9);
    const greyBg = Color(0xFFF5F5F5);
    const darkGrey = Color(0xFF424242);

    return Container(
      width: 258,
      decoration: BoxDecoration(
        color: greyBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 0),
          ),
        ],
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.asset(
              "assets/images/123.png",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                children: [
                  SizedBox(height: 8),

                  _buildMenuItem(
                    icon: Icons.dashboard,
                    label: "Dashboard",
                    index: 0,
                    isSelected: selectedIndex == 0,
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_bag,
                    label: "Orders",
                    index: 1,
                    isSelected: selectedIndex == 1,
                  ),
                  _buildMenuItem(
                    icon: Icons.inventory,
                    label: "Products",
                    index: 2,
                    isSelected: selectedIndex == 2,
                  ),
                  _buildMenuItem(
                    icon: Icons.category,
                    label: "Categories",
                    index: 3,
                    isSelected: selectedIndex == 3,
                  ),
                  _buildMenuItem(
                    icon: Icons.group,
                    label: "Customers",
                    index: 4,
                    isSelected: selectedIndex == 4,
                  ),
                  _buildMenuItem(
                    icon: Icons.payment,
                    label: "Payments",
                    index: 5,
                    isSelected: selectedIndex == 5,
                  ),
                  _buildMenuItem(
                    icon: Icons.local_offer,
                    label: "Promotions",
                    index: 6,
                    isSelected: selectedIndex == 6,
                  ),

                  SizedBox(height: 24),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "ANALYTICS",
                      style: TextStyle(
                        color: darkGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  _buildMenuItem(
                    icon: Icons.analytics,
                    label: "Reports",
                    index: 7,
                    isSelected: selectedIndex == 7,
                  ),
                  _buildMenuItem(
                    icon: Icons.trending_up,
                    label: "Insights",
                    index: 8,
                    isSelected: selectedIndex == 8,
                  ),

                  SizedBox(height: 32),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: greyBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SYSTEM",
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 12),

                        _buildSystemItem(
                          icon: Icons.settings,
                          label: "Settings",
                          color: Colors.blue[700],
                        ),
                        SizedBox(height: 8),
                        _buildSystemItem(
                          icon: Icons.help_outline,
                          label: "Help & Support",
                          color: Colors.orange[700],
                        ),
                        SizedBox(height: 8),
                        _buildSystemItem(
                          icon: Icons.feedback_outlined,
                          label: "Feedback",
                          color: Colors.purple[700],
                        ),
                        SizedBox(height: 8),
                        _buildSystemItem(
                          icon: Icons.logout,
                          label: "Logout",
                          color: Colors.red[700],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    String? notificationCount,
    bool hasNotification = false,
  }) {
    const green = Color(0xFF4CAF50);
    const darkGreen = Color(0xFF388E3C);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected ? green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => onMenuSelected(index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border(
                left: BorderSide(color: darkGreen, width: 3),
              )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? green : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? darkGreen : Colors.grey[800],
                    ),
                  ),
                ),

                if (notificationCount != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      notificationCount,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (hasNotification)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemItem({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: color ?? Colors.grey[600],
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}