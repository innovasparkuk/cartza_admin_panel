// main.dart
import 'package:ecomadminpanel/admin_dashboard.dart';
import 'package:ecomadminpanel/admin_provider.dart';
import 'package:ecomadminpanel/product_management.dart';
import 'package:ecomadminpanel/stock_management.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const ResponsiveLayout(child: AdminDashboard()),
      ),
    );
  }
}

// Responsive Layout Wrapper
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileScaffold(child: child);
        } else if (constraints.maxWidth < 1200) {
          return TabletScaffold(child: child);
        } else {
          return DesktopScaffold(child: child);
        }
      },
    );
  }
}

class MobileScaffold extends StatelessWidget {
  final Widget child;
  const MobileScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(child: child),
    );
  }
}

class TabletScaffold extends StatelessWidget {
  final Widget child;
  const TabletScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(child: child),
    );
  }
}

class DesktopScaffold extends StatelessWidget {
  final Widget child;
  const DesktopScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Flexible(
            flex: 1,
            child: AppDrawer(),
          ),
          Flexible(
            flex: 5,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Product Management'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductManagementPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.warehouse),
            title: const Text('Stock Management'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StockManagementPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
