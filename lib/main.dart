import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';

void main() {
  runApp(ShopEaseAdminApp());
}

class ShopEaseAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,

        primaryColor: Color(0xFF111111),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF111111),
          primary: Color(0xFF111111),
          secondary: Color(0xFF00C853),
          background: Color(0xFFF4F6F8),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF212121),
          onSurface: Color(0xFF212121),
        ),

        scaffoldBackgroundColor: Color(0xFFF4F6F8),

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF111111),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          shadowColor: Colors.black12,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00C853),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00C853),
          ),
        ),

        iconTheme: IconThemeData(
          color: Color(0xFF212121),
          size: 22,
        ),

        dividerTheme: DividerThemeData(
          color: Colors.grey[300],
          thickness: 1,
        ),

        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF212121),
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFF00C853),
              width: 2,
            ),
          ),
        ),
      ),
      home: DashboardPage(),
    );
  }
}
