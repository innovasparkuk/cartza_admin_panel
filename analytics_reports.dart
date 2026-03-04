import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const AnalyticsDashboardApp());
}

class AnalyticsDashboardApp extends StatelessWidget {
  const AnalyticsDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analytics Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6F00),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _selectedView = 0;
  String _dateRange = '90';
  bool _showExportToast = false;
  int? _selectedMetricCard;
  String _toastMessage = 'Report exported successfully!';
  bool _showReportModal = false;
  String _currentReportType = '';
  bool _isGeneratingReport = false;
  bool _showUpgradeDialog = false;
  bool _showAllTransactions = false;
  bool _showExportDialog = false;
  String _exportFormat = 'CSV (Spreadsheet)';
  String _exportData = 'Current View';

  late AnimationController _pulseController;
  late AnimationController _slideController;

  List<Transaction> _transactions = [
    Transaction('#ORD-7821', 'John Doe', 1250.00, 'Completed', 'JD', const Color(0xFFFF6F00)),
    Transaction('#ORD-7820', 'Sarah Miller', 892.00, 'Pending', 'SM', const Color(0xFF4CAF50)),
    Transaction('#ORD-7819', 'Robert Johnson', 2100.00, 'Completed', 'RJ', const Color(0xFF212121)),
    Transaction('#ORD-7818', 'Emily Wilson', 445.00, 'Cancelled', 'EW', const Color(0xFFFF6F00)),
    Transaction('#ORD-7817', 'Michael Brown', 1850.00, 'Completed', 'MB', const Color(0xFF4CAF50)),
    Transaction('#ORD-7816', 'Jessica Davis', 620.00, 'Pending', 'JD', const Color(0xFFFF6F00)),
  ];

  List<User> _users = [
    User('John Doe', 'john.doe@email.com', 'Premium', 'Active', 'JD', const Color(0xFFFF6F00)),
    User('Sarah Miller', 'sarah.miller@email.com', 'Free', 'Active', 'SM', const Color(0xFF4CAF50)),
    User('Robert Johnson', 'robert.j@email.com', 'Premium', 'Pending', 'RJ', const Color(0xFF212121)),
  ];

  final List<double> revenueData = [65, 45, 75, 55, 80, 70, 90, 85, 95, 75, 88, 92];
  final List<double> expenseData = [40, 35, 45, 38, 50, 42, 55, 48, 58, 45, 52, 56];

  List<ReportItem> _recentReports = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    setState(() {
      _toastMessage = message;
      _showExportToast = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showExportToast = false);
    });
  }

  void _changeTransactionStatus(int index) {
    final statuses = ['Completed', 'Pending', 'Cancelled'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return ListTile(
              title: Text(status),
              onTap: () {
                setState(() {
                  _transactions[index] = Transaction(
                    _transactions[index].id,
                    _transactions[index].name,
                    _transactions[index].amount,
                    status,
                    _transactions[index].initials,
                    _transactions[index].color,
                  );
                });
                Navigator.pop(context);
                _showToast('Status updated to $status');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _changeUserStatus(int index) {
    final statuses = ['Active', 'Pending', 'Inactive'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change User Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return ListTile(
              title: Text(status),
              onTap: () {
                setState(() {
                  _users[index] = User(
                    _users[index].name,
                    _users[index].email,
                    _users[index].plan,
                    status,
                    _users[index].initials,
                    _users[index].color,
                  );
                });
                Navigator.pop(context);
                _showToast('User status updated to $status');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _addUser() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedPlan = 'Free';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPlan,
              decoration: const InputDecoration(
                labelText: 'Plan',
                border: OutlineInputBorder(),
              ),
              items: ['Free', 'Premium'].map((plan) {
                return DropdownMenuItem(value: plan, child: Text(plan));
              }).toList(),
              onChanged: (value) => selectedPlan = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final initials = nameController.text.split(' ').map((e) => e[0]).take(2).join();
                setState(() {
                  _users.add(User(
                    nameController.text,
                    emailController.text,
                    selectedPlan,
                    'Active',
                    initials,
                    const Color(0xFF4CAF50),
                  ));
                });
                Navigator.pop(context);
                _showToast('User added successfully!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _generateReport(String type) {
    setState(() {
      _currentReportType = type;
      _showReportModal = true;
      _isGeneratingReport = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGeneratingReport = false;
        _recentReports.insert(0, ReportItem(
          type: type,
          date: DateTime.now(),
          status: 'Completed',
        ));
      });
    });
  }

  void _downloadReport() {
    _showToast('Report downloaded successfully as PDF!');
    setState(() => _showReportModal = false);
  }

  void _handleExport() {
    setState(() => _showExportDialog = false);
    _showToast('Report exported as $_exportFormat successfully!');
  }

  List<String> _getDateLabels() {
    if (_dateRange == '7') {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final now = DateTime.now();
      return List.generate(7, (i) {
        final date = now.subtract(Duration(days: 6 - i));
        return days[date.weekday - 1];
      });
    } else if (_dateRange == '30') {
      return List.generate(12, (i) => '${i * 3 + 1}');
    } else if (_dateRange == '90') {
      return ['Week 1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'W10', 'W11', 'W12'];
    } else {
      return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }
  }

  List<double> _getRevenueDataForRange() {
    final random = Random(42);
    if (_dateRange == '7') {
      return List.generate(7, (i) => 40 + random.nextDouble() * 60);
    } else if (_dateRange == '30') {
      return List.generate(12, (i) => 45 + random.nextDouble() * 55);
    } else if (_dateRange == '90') {
      return List.generate(12, (i) => 50 + random.nextDouble() * 50);
    } else {
      return revenueData;
    }
  }

  List<double> _getExpenseDataForRange() {
    final random = Random(24);
    if (_dateRange == '7') {
      return List.generate(7, (i) => 25 + random.nextDouble() * 40);
    } else if (_dateRange == '30') {
      return List.generate(12, (i) => 30 + random.nextDouble() * 35);
    } else if (_dateRange == '90') {
      return List.generate(12, (i) => 35 + random.nextDouble() * 35);
    } else {
      return expenseData;
    }
  }

  List<TrafficSource> _getTrafficDataForRange() {
    final random = Random(100);
    if (_dateRange == '7') {
      return [
        TrafficSource('Organic Search', 35 + random.nextInt(10), const Color(0xFFFF6F00)),
        TrafficSource('Direct', 25 + random.nextInt(8), const Color(0xFF4CAF50)),
        TrafficSource('Social Media', 20 + random.nextInt(10), const Color(0xFF212121)),
        TrafficSource('Referral', 15 + random.nextInt(5), const Color(0xFF9E9E9E)),
      ];
    } else if (_dateRange == '30') {
      return [
        TrafficSource('Organic Search', 38 + random.nextInt(8), const Color(0xFFFF6F00)),
        TrafficSource('Direct', 27 + random.nextInt(6), const Color(0xFF4CAF50)),
        TrafficSource('Social Media', 18 + random.nextInt(8), const Color(0xFF212121)),
        TrafficSource('Referral', 12 + random.nextInt(5), const Color(0xFF9E9E9E)),
      ];
    } else if (_dateRange == '90') {
      return [
        TrafficSource('Organic Search', 40, const Color(0xFFFF6F00)),
        TrafficSource('Direct', 25, const Color(0xFF4CAF50)),
        TrafficSource('Social Media', 20, const Color(0xFF212121)),
        TrafficSource('Referral', 15, const Color(0xFF9E9E9E)),
      ];
    } else {
      return [
        TrafficSource('Organic Search', 42 + random.nextInt(6), const Color(0xFFFF6F00)),
        TrafficSource('Direct', 28 + random.nextInt(5), const Color(0xFF4CAF50)),
        TrafficSource('Social Media', 17 + random.nextInt(6), const Color(0xFF212121)),
        TrafficSource('Referral', 10 + random.nextInt(5), const Color(0xFF9E9E9E)),
      ];
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Map<String, dynamic> _getMetricsForDateRange() {
    final multipliers = {
      '7': 0.2,
      '30': 1.0,
      '90': 2.5,
      '365': 10.0,
    };
    final multiplier = multipliers[_dateRange] ?? 1.0;

    return {
      'revenue': (84254 * multiplier).toInt(),
      'users': (24521 * multiplier).toInt(),
      'orders': (12847 * multiplier).toInt(),
      'sales': (12426 * multiplier).toInt(),
      'todayOrders': (156 * multiplier).toInt(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: IndexedStack(
                        index: _selectedView,
                        children: [
                          _buildOverviewView(),
                          _buildReportsView(),
                          _buildAnalyticsView(),
                          _buildSalesView(),
                          _buildUsersView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showExportToast)
            Positioned(
              bottom: 20,
              right: 20,
              child: _buildExportToast(),
            ),
          if (_showReportModal) _buildReportModal(),
          if (_showUpgradeDialog) _buildUpgradeDialog(),
          if (_showAllTransactions) _buildAllTransactionsDialog(),
          if (_showExportDialog) _buildExportDialog(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 256,
      color: const Color(0xFF212121),
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(child: _buildNavigation()),
          _buildUpgradeCard(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF424242))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F00),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6F00).withOpacity(0.5),
                  blurRadius: 15,
                ),
              ],
            ),
            child: const Icon(Icons.bar_chart, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Analytics Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Dashboard', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    final items = [
      {'icon': Icons.dashboard, 'label': 'Overview'},
      {'icon': Icons.insert_chart, 'label': 'Reports'},
      {'icon': Icons.analytics, 'label': 'Analytics'},
      {'icon': Icons.monetization_on, 'label': 'Sales'},
      {'icon': Icons.people, 'label': 'Users'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final isActive = _selectedView == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedView = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFF6F00).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: isActive ? const Color(0xFFFF6F00) : Colors.transparent,
                  width: 4,
                ),
              ),
              boxShadow: isActive ? [BoxShadow(color: const Color(0xFFFF6F00).withOpacity(0.3), blurRadius: 15)] : [],
            ),
            child: Row(
              children: [
                Icon(items[index]['icon'] as IconData, color: isActive ? const Color(0xFFFF6F00) : const Color(0xFF9E9E9E), size: 20),
                const SizedBox(width: 12),
                Text(items[index]['label'] as String, style: TextStyle(color: isActive ? Colors.white : const Color(0xFFBDBDBD), fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpgradeCard() {
    return GestureDetector(
      onTap: () => setState(() => _showUpgradeDialog = true),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF6F00), Color(0xFF4CAF50)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: const Color(0xFFFF6F00).withOpacity(0.5), blurRadius: 15)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pro Features', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            const Text('Unlock analytics', style: TextStyle(color: Color(0xFFFFE0B2), fontSize: 11)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _showUpgradeDialog = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF6F00),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Upgrade', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 450,
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium, size: 70, color: Color(0xFFFF6F00)),
                const SizedBox(height: 20),
                const Text('Upgrade to Pro', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('Get access to advanced features:', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF757575))),
                const SizedBox(height: 20),
                _buildFeatureItem('Real-time data updates'),
                _buildFeatureItem('Advanced reporting tools'),
                _buildFeatureItem('Custom dashboards'),
                _buildFeatureItem('Priority support'),
                _buildFeatureItem('Export unlimited reports'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _showUpgradeDialog = false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Maybe Later'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _showUpgradeDialog = false);
                          _showToast('Upgrade successful! Welcome to Pro!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6F00),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Upgrade Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildExportDialog() {
    return Container(
      color: Colors.black54,  // ← This makes background semi-transparent
      child: Center(
        child: Container(
          width: 380,
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Export Report',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () => setState(() => _showExportDialog = false),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Format',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _exportFormat,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        dropdownColor: Colors.white,
                        style:  TextStyle(color: Colors.black, fontSize: 14),
                        items:  [
                          DropdownMenuItem(value: 'CSV (Spreadsheet)', child: Text('CSV (Spreadsheet)')),
                          DropdownMenuItem(value: 'PDF Document', child: Text('PDF Document')),
                          DropdownMenuItem(value: 'Excel Workbook', child: Text('Excel Workbook')),
                          DropdownMenuItem(value: 'JSON Data', child: Text('JSON Data')),
                        ],
                        onChanged: (value) => setState(() => _exportFormat = value!),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Data to Export',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _exportData,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                        items: const [
                          DropdownMenuItem(value: 'Current View', child: Text('Current View')),
                          DropdownMenuItem(value: 'All Data', child: Text('All Data')),
                          DropdownMenuItem(value: 'Selected Range', child: Text('Selected Range')),
                          DropdownMenuItem(value: 'Custom Selection', child: Text('Custom Selection')),
                        ],
                        onChanged: (value) => setState(() => _exportData = value!),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleExport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                    ),
                    child: const Text(
                      'Export Report',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reports & Analytics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                SizedBox(height: 4),
                Text('Track your business performance', style: TextStyle(color: Color(0xFF757575), fontSize: 14)),
              ],
            ),
          ),
          _buildDateRangeDropdown(),
          const SizedBox(width: 16),
          _buildExportButton(),
          const SizedBox(width: 16),
          _buildNotificationButton(),
        ],
      ),
    );
  }

  Widget _buildDateRangeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _dateRange,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: '7', child: Text('Last 7 days')),
          DropdownMenuItem(value: '30', child: Text('Last 30 days')),
          DropdownMenuItem(value: '90', child: Text('Last 90 days')),
          DropdownMenuItem(value: '365', child: Text('Last year')),
        ],
        onChanged: (value) => setState(() => _dateRange = value!),
      ),
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: () => setState(() => _showExportDialog = true),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF6F00),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.download, size: 18),
      label: const Text('Export Report', style: TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _showToast('No new notifications'),
          color: const Color(0xFF757575),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F00),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6F00).withOpacity(0.3 + _pulseController.value * 0.5),
                      blurRadius: 10 + _pulseController.value * 10,
                      spreadRadius: _pulseController.value * 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildWebFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const Text(
        '© 2025 Dashboard',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildOverviewView() {
    final metrics = _getMetricsForDateRange();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildMetricsGrid(metrics),
          const SizedBox(height: 32),
          _buildChartsRow(),
          const SizedBox(height: 32),
          _buildRecentTransactions(),
          const SizedBox(height: 32),
          _buildWebFooter(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Map<String, dynamic> metrics) {
    final metricsList = [
      {
        'icon': Icons.monetization_on,
        'label': 'Total Revenue',
        'value': "\$${metrics['revenue']}",
        'change': '+12.5%',
        'isPositive': true,
        'color': const Color(0xFFFF6F00),
      },
      {
        'icon': Icons.people,
        'label': 'Active Users',
        'value': "${metrics['users']}",
        'change': '+8.2%',
        'isPositive': true,
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.shopping_bag,
        'label': 'Total Orders',
        'value': "${metrics['orders']}",
        'change': '-3.1%',
        'isPositive': false,
        'color': const Color(0xFFFF6F00),
      },
      {
        'icon': Icons.trending_up,
        'label': 'Conversion Rate',
        'value': '3.24%',
        'change': '+5.4%',
        'isPositive': true,
        'color': const Color(0xFF4CAF50),
      },
    ];




  return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 600 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: metricsList.length,
          itemBuilder: (context, index) => _buildMetricCard(metricsList[index], index),
        );
      },
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric, int index) {
    final isSelected = _selectedMetricCard == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMetricCard = isSelected ? null : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? (metric['color'] as Color) : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: isSelected ? (metric['color'] as Color).withOpacity(0.5) : Colors.black12, blurRadius: isSelected ? 25 : 8, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (metric['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: (metric['color'] as Color).withOpacity(0.5), blurRadius: 15)],
                  ),
                  child: Icon(metric['icon'] as IconData, color: metric['color'] as Color, size: 24),
                ),
                Row(
                  children: [
                    Icon(metric['isPositive'] as bool ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: metric['isPositive'] as bool ? const Color(0xFF4CAF50) : Colors.red),
                    Text(metric['change'] as String, style: TextStyle(color: metric['isPositive'] as bool ? const Color(0xFF4CAF50) : Colors.red, fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(metric['label'] as String, style: const TextStyle(color: Color(0xFF757575), fontSize: 14)),
            const SizedBox(height: 4),
            Text(metric['value'] as String, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
          ],
        ),
      ),
    );
  }
  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildRevenueChart()),  // Revenue chart on left (bigger)
        const SizedBox(width: 24),
        Expanded(child: _buildTrafficSources()),  // Traffic sources on right (smaller)
      ],
    );
  }

  Widget _buildRevenueChart() {
    final labels = _getDateLabels();
    final data = _getRevenueDataForRange();
    final expData = _getExpenseDataForRange();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Monthly revenue breakdown', style: TextStyle(color: Color(0xFF757575), fontSize: 14)),
                ],
              ),
              Wrap(
                spacing: 16,
                children: [
                  _buildLegendItem('Revenue', const Color(0xFFFF6F00)),
                  _buildLegendItem('Expenses', const Color(0xFF4CAF50)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 280,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (index) {
                final revenueValue = (data[index] * 1000).toInt();
                final expenseValue = (expData[index] * 1000).toInt();
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Revenue bar (orange)
                        Expanded(
                          child: _buildChartBar(
                            data[index] / 100,
                            const Color(0xFFFF6F00),
                            '\$revenueValue',
                            showValueOnTap: true,
                          ),
                        ),
                        const SizedBox(width: 2),
                        // Expense bar (green)
                        Expanded(
                          child: _buildChartBar(
                            expData[index] / 100,
                            const Color(0xFF4CAF50),
                            '\$expenseValue',
                            showValueOnTap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labels.asMap().entries.map((entry) => Padding(
                padding: EdgeInsets.symmetric(horizontal: data.length > 7 ? 12 : 16),
                child: Text(entry.value, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E), fontWeight: FontWeight.w500)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildChartBar(double value, Color color, String tooltipText, {bool showValueOnTap = false}) {
    return GestureDetector(
      onTap: showValueOnTap ? () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Value Details'),
            content: Text('Amount: $tooltipText'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } : null,
      child: Tooltip(
        message: tooltipText,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        child: Container(
          height: value * 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Color(0xFF757575), fontSize: 14)),
      ],
    );
  }

  Widget _buildTrafficSources() {
    final trafficData = _getTrafficDataForRange();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Traffic Sources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('Where visitors come from', style: TextStyle(color: Color(0xFF757575), fontSize: 14)),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                String details = trafficData.map((source) => '${source.label}: ${source.percentage}%').join('\n');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Traffic Sources Details'),
                    content: Text(details),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: SizedBox(
                width: 160,
                height: 160,
                child: CustomPaint(painter: DonutChartPainter(trafficData)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...trafficData.map((source) => _buildTrafficSourceItem(source.label, source.percentage, source.color)).toList(),
        ],
      ),
    );
  }

  Widget _buildTrafficSourceItem(String label, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: '$label: $percentage visitors',
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(fontSize: 14)),
                ],
              ),
              Text('$percentage%', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Latest order activity', style: TextStyle(color: Color(0xFF757575), fontSize: 14)),
                  ],
                ),
                TextButton(
                  onPressed: () => setState(() => _showAllTransactions = true),
                  child: const Text('View All', style: TextStyle(color: Color(0xFFFF6F00), fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          ...List.generate(min(4, _transactions.length), (index) => _buildTransactionRow(index)),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(int index) {
    final transaction = _transactions[index];
    return InkWell(
      onTap: () => _changeTransactionStatus(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(transaction.id, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w500)),
                      _buildStatusBadge(transaction.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [transaction.color, transaction.color.withOpacity(0.7)]),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: transaction.color.withOpacity(0.5), blurRadius: 10)],
                        ),
                        child: Center(
                          child: Text(transaction.initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.name),
                            Text('\${transaction.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(transaction.id, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [transaction.color, transaction.color.withOpacity(0.7)]),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: transaction.color.withOpacity(0.5), blurRadius: 10)],
                        ),
                        child: Center(
                          child: Text(transaction.initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(transaction.name),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text('\${transaction.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 2,
                  child: _buildStatusBadge(transaction.status),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor, textColor;
    if (status == 'Completed') {
      bgColor = const Color(0xFF4CAF50).withOpacity(0.2);
      textColor = const Color(0xFF4CAF50);
    } else if (status == 'Pending') {
      bgColor = const Color(0xFFFF6F00).withOpacity(0.2);
      textColor = const Color(0xFFFF6F00);
    } else {
      bgColor = Colors.red.withOpacity(0.2);
      textColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: textColor.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
    );
  }

  Widget _buildAllTransactionsDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 900,
          height: 600,
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('All Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _showAllTransactions = false),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) => _buildTransactionRow(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Generate and download detailed reports', style: TextStyle(color: Color(0xFF757575))),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 700 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.2,
                children: [
                  _buildReportCard('Sales Report', 'Complete sales breakdown and analysis', Icons.insert_chart, const Color(0xFFFF6F00), 'sales'),
                  _buildReportCard('Revenue Report', 'Revenue analysis with detailed trends', Icons.monetization_on, const Color(0xFF4CAF50), 'revenue'),
                  _buildReportCard('User Report', 'Comprehensive user analytics and insights', Icons.people, const Color(0xFF212121), 'user'),
                ],
              );
            },
          ),
          if (_recentReports.isNotEmpty) ...[
            const SizedBox(height: 48),
            const Text('Recent Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Column(
                children: _recentReports.map((report) => _buildReportItem(report)).toList(),
              ),
            ),
          ],
          const SizedBox(height: 32),
          _buildWebFooter(),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String description, IconData icon, Color color, String type) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 15)],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Color(0xFF757575), fontSize: 14)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _generateReport(type),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Generate Report'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(ReportItem report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${report.type.toUpperCase()} Report', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(_formatDate(report.date), style: const TextStyle(color: Color(0xFF757575), fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showToast('Report downloaded!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),

            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 800,
          height: 600,
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFF6F00), Color(0xFFFF8F00)]),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_currentReportType.toUpperCase()} Report',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Generated on ${_formatDate(DateTime.now())}',
                          style: const TextStyle(color: Color(0xFFFFE0B2), fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _showReportModal = false),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isGeneratingReport
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFFF6F00)),
                      SizedBox(height: 16),
                      Text('Generating your report...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
                    : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildReportContent(),
                ),
              ),
              if (!_isGeneratingReport)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                          SizedBox(width: 8),
                          Text('Report generated successfully', style: TextStyle(color: Color(0xFF757575))),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => setState(() => _showReportModal = false),
                            child: const Text('Close'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _downloadReport,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white),
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Download PDF'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    final metrics = _getMetricsForDateRange();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Report Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
              children: [
                _buildReportStat('Total Sales', '\$${metrics['sales']}', '+12.5%'),
                _buildReportStat('Orders', '${metrics['orders']}', '+8.2%'),
                _buildReportStat('Avg Order', '\$73.95', '+3.8%'),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const Text('Detailed Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildReportTable(),
        ),
      ],
    );
  }

  Widget _buildReportStat(String label, String value, String change) {
    final isPositive = change.contains('+');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF757575), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(change, style: TextStyle(color: isPositive ? const Color(0xFF4CAF50) : Colors.red, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReportTable() {
    return Table(
      border: TableBorder.all(color: const Color(0xFFE0E0E0)),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
          children: [
            _buildTableCell('Product Name', isHeader: true),
            _buildTableCell('Units Sold', isHeader: true),
            _buildTableCell('Total Revenue', isHeader: true),
          ],
        ),
        TableRow(children: [
          _buildTableCell('Premium Laptop'),
          _buildTableCell('1,234'),
          _buildTableCell('\$123,400'),
        ]),
        TableRow(children: [
          _buildTableCell('Smartphone Ultra'),
          _buildTableCell('892'),
          _buildTableCell('\$89,200'),
        ]),
        TableRow(children: [
          _buildTableCell('Wireless Headphones'),
          _buildTableCell('2,156'),
          _buildTableCell('\$43,120'),
        ]),
        TableRow(children: [
          _buildTableCell('Smart Watch'),
          _buildTableCell('567'),
          _buildTableCell('\$28,350'),
        ]),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAnalyticsView() {
    final metrics = _getMetricsForDateRange();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Analytics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Deep dive into your performance metrics', style: TextStyle(color: Color(0xFF757575))),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return Column(
                  children: [
                    _buildConversionFunnel(),
                    const SizedBox(height: 24),
                    _buildPerformanceMetrics(metrics),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _buildConversionFunnel()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildPerformanceMetrics(metrics)),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _buildDeviceBreakdown(),
        ],
      ),
    );
  }

  Widget _buildConversionFunnel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Conversion Funnel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildFunnelItem('Visitors', 50000, 1.0, const Color(0xFFFF6F00)),
          _buildFunnelItem('Sign Ups', 15000, 0.3, const Color(0xFFFF6F00)),
          _buildFunnelItem('Active Users', 8500, 0.17, const Color(0xFF4CAF50)),
          _buildFunnelItem('Paying Customers', 2100, 0.042, const Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  Widget _buildFunnelItem(String label, int value, double width, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 24,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: width,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(Map<String, dynamic> metrics) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                return Column(
                  children: [
                    _buildMetricBox('Bounce Rate', '32.4%', '↓ 2.1% vs last month', const Color(0xFFFF6F00)),
                    const SizedBox(height: 16),
                    _buildMetricBox('Avg. Session', '4m 32s', '↑ 18% vs last month', const Color(0xFF4CAF50)),
                    const SizedBox(height: 16),
                    _buildMetricBox('Pages/Session', '5.8', '↑ 8% vs last month', const Color(0xFF4CAF50)),
                    const SizedBox(height: 16),
                    _buildMetricBox('New Users', '67%', '↓ 3% vs last month', const Color(0xFFFF6F00)),
                  ],
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildMetricBox('Bounce Rate', '32.4%', '↓ 2.1% vs last month', const Color(0xFFFF6F00))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricBox('Avg. Session', '4m 32s', '↑ 18% vs last month', const Color(0xFF4CAF50))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMetricBox('Pages/Session', '5.8', '↑ 8% vs last month', const Color(0xFF4CAF50))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricBox('New Users', '67%', '↓ 3% vs last month', const Color(0xFFFF6F00))),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF757575), fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(change, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDeviceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Device Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _buildDeviceItem(Icons.phone_android, '58%', 'Mobile', const Color(0xFFFF6F00)),
                    const SizedBox(height: 16),
                    _buildDeviceItem(Icons.computer, '35%', 'Desktop', const Color(0xFF4CAF50)),
                    const SizedBox(height: 16),
                    _buildDeviceItem(Icons.tablet, '7%', 'Tablet', const Color(0xFF212121)),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDeviceItem(Icons.phone_android, '58%', 'Mobile', const Color(0xFFFF6F00)),
                  _buildDeviceItem(Icons.computer, '35%', 'Desktop', const Color(0xFF4CAF50)),
                  _buildDeviceItem(Icons.tablet, '7%', 'Tablet', const Color(0xFF212121)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(IconData icon, String percentage, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 16),
          Text(percentage, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(color: Color(0xFF757575))),
        ],
      ),
    );
  }

  Widget _buildSalesView() {
    final metrics = _getMetricsForDateRange();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Track your sales performance and revenue', style: TextStyle(color: Color(0xFF757575))),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _buildSalesCard('Today\'s Sales', '\$${metrics['sales']}', Icons.monetization_on, const Color(0xFFFF6F00)),
                    const SizedBox(height: 16),
                    _buildSalesCard('Today\'s Orders', '${metrics['todayOrders']}', Icons.shopping_bag, const Color(0xFF4CAF50)),
                    const SizedBox(height: 16),
                    _buildSalesCard('Avg. Order Value', '\$79.65', Icons.trending_up, const Color(0xFF212121)),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _buildSalesCard('Today\'s Sales', '\$${metrics['sales']}', Icons.monetization_on, const Color(0xFFFF6F00))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSalesCard('Today\'s Orders', '${metrics['todayOrders']}', Icons.shopping_bag, const Color(0xFF4CAF50))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSalesCard('Avg. Order Value', '\$79.65', Icons.trending_up, const Color(0xFF212121))),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          _buildTopSellingProducts(),
        ],
      ),
    );
  }

  Widget _buildSalesCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF757575), fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProducts() {
    final products = [
      {'name': 'Premium Laptop', 'sold': 2341, 'revenue': 234100, 'color': const Color(0xFFFF6F00), 'icon': Icons.laptop},
      {'name': 'Smartphone Pro', 'sold': 1892, 'revenue': 189200, 'color': const Color(0xFF4CAF50), 'icon': Icons.phone_android},
      {'name': 'Wireless Headphones', 'sold': 1456, 'revenue': 72800, 'color': const Color(0xFF212121), 'icon': Icons.headphones},
      {'name': 'Smart Watch', 'sold': 1123, 'revenue': 56150, 'color': const Color(0xFFFF6F00), 'icon': Icons.watch},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Selling Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...products.map((product) => _buildProductItem(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    final maxRevenue = 234100.0;
    final percentage = (product['revenue'] as int) / maxRevenue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (product['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(product['icon'] as IconData, color: product['color'] as Color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${product['sold']} sold • \$${product['revenue']}', style: const TextStyle(color: Color(0xFF757575), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: product['color'] as Color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: (product['color'] as Color).withOpacity(0.5), blurRadius: 8)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Users', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Manage and analyze user base', style: TextStyle(color: Color(0xFF757575))),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        icon: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Color(0xFF4CAF50), size: 20),
                        ),
                        label: const Text('Add User', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Users', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Manage and analyze user base', style: TextStyle(color: Color(0xFF757575))),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _addUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF4CAF50), size: 20),
                    ),
                    label: const Text('Add User', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('User List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
                ...List.generate(_users.length, (index) => _buildUserRow(index)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(int index) {
    final user = _users[index];
    return InkWell(
      onTap: () => _changeUserStatus(index),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [user.color, user.color.withOpacity(0.7)]),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: user.color.withOpacity(0.5), blurRadius: 10)],
                        ),
                        child: Center(
                          child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text(user.email, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: user.plan == 'Premium' ? const Color(0xFFFF6F00).withOpacity(0.1) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.plan,
                          style: TextStyle(
                            color: user.plan == 'Premium' ? const Color(0xFFFF6F00) : const Color(0xFF757575),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(user.status),
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [user.color, user.color.withOpacity(0.7)]),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: user.color.withOpacity(0.5), blurRadius: 10)],
                        ),
                        child: Center(
                          child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(flex: 3, child: Text(user.email, style: const TextStyle(color: Color(0xFF757575)))),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: user.plan == 'Premium' ? const Color(0xFFFF6F00).withOpacity(0.1) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.plan,
                      style: TextStyle(
                        color: user.plan == 'Premium' ? const Color(0xFFFF6F00) : const Color(0xFF757575),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(flex: 2, child: _buildStatusBadge(user.status)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExportToast() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.5), blurRadius: 15, spreadRadius: 2)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(_toastMessage, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class Transaction {
  final String id;
  final String name;
  final double amount;
  final String status;
  final String initials;
  final Color color;

  const Transaction(this.id, this.name, this.amount, this.status, this.initials, this.color);
}

class User {
  final String name;
  final String email;
  final String plan;
  final String status;
  final String initials;
  final Color color;

  const User(this.name, this.email, this.plan, this.status, this.initials, this.color);
}

class ReportItem {
  final String type;
  final DateTime date;
  final String status;

  const ReportItem({required this.type, required this.date, required this.status});
}

class TrafficSource {
  final String label;
  final int percentage;
  final Color color;

  const TrafficSource(this.label, this.percentage, this.color);
}

class DonutChartPainter extends CustomPainter {
  final List<TrafficSource> data;

  const DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -90 * 3.14159 / 180;

    for (var source in data) {
      final sweepAngle = (source.percentage / 100) * 360 * 3.14159 / 180;
      paint.color = source.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}