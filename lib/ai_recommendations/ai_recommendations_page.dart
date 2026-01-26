import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shimmer/shimmer.dart';
import '../services/public_ai_proxy.dart';
import '../theme/theme_provider.dart';
import '../services/ai.dart';

class AIRecommendationsPage extends StatefulWidget {
  const AIRecommendationsPage({super.key});

  @override
  State<AIRecommendationsPage> createState() => _AIRecommendationsPageState();
}

class _AIRecommendationsPageState extends State<AIRecommendationsPage> {
  final HuggingFaceAI _ai = HuggingFaceAI();

  bool _loading = false;
  String _tab = 'products';
  final Map<String, String> _responses = {};

  final _product = TextEditingController(text: 'Wireless Headphones');
  final _category = TextEditingController(text: 'Electronics');
  final _price = TextEditingController(text: '2999');
  final _stock = TextEditingController(text: '150');

  @override
  void initState() {
    super.initState();
    for (var t in ['products','sales','marketing','customers','inventory']) {
      _responses[t] = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    context.watch<ThemeProvider>().isDark;

    return Scaffold(
      body: Column(
        children: [
          _tabs(theme),
          if (_tab == 'products') _productInputs(),
          _generateButton(),
          Expanded(child: _resultSection()),
        ],
      ),
    );
  }

  Widget _tabs(ThemeData theme) {
    return Container(
      height: 52,
      color: theme.colorScheme.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _tabItem('products', Icons.shopping_bag, 'Products'),
          _tabItem('sales', Icons.show_chart, 'Sales'),
          _tabItem('marketing', Icons.campaign, 'Marketing'),
          _tabItem('customers', Icons.people, 'Customers'),
          _tabItem('inventory', Icons.inventory, 'Inventory'),
        ],
      ),
    );
  }

  Widget _tabItem(String id, IconData icon, String text) {
    final active = _tab == id;
    return InkWell(
      onTap: () => setState(() => _tab = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 3,
              color: active ? Colors.green : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.green : Colors.grey),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productInputs() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _field(_product, 'Product Name'),
          const SizedBox(height: 10),
          _field(_category, 'Category'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _field(_price, 'Price')),
              const SizedBox(width: 10),
              Expanded(child: _field(_stock, 'Stock')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _generateButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: Colors.green,
        ),
        onPressed: _loading ? null : _generate,
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          'Generate ${_tab.toUpperCase()} Insights',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _resultSection() {
    final text = _responses[_tab] ?? '';

    if (_loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(
              6,
                  (_) => Container(
                height: 16,
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    if (text.isEmpty) {
      return const Center(
        child: Text('Generate AI insights to view analysis'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView( // ✅ ADD THIS
            child: MarkdownBody(
              data: text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(height: 1.6),
              ),
            ),
          ),
        ),
      ),

    );
  }

  Future<void> _generate() async {
    setState(() => _loading = true);

    try {
      String r = '';

      switch (_tab) {
        case 'products':
          r = await _ai.productAnalysis(
            name: _product.text,
            category: _category.text,
            price: double.tryParse(_price.text) ?? 0,
            stock: int.tryParse(_stock.text) ?? 0,
          );
          break;
        case 'sales':
          r = await _ai.salesAnalysis();
          break;
        case 'marketing':
          r = await _ai.marketingPlan();
          break;
        case 'customers':
          r = await _ai.customerInsights();
          break;
        case 'inventory':
          r = await _ai.inventoryPlan();
          break;
      }

      setState(() => _responses[_tab] = r);
    } catch (_) {
      setState(() {
        _responses[_tab] =
        'Unable to generate insights at the moment. Please try again.';
      });
    } finally {
      // ✅ loading ALWAYS stops
      setState(() => _loading = false);
    }
  }
}





