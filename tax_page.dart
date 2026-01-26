import 'package:flutter/material.dart';

// Tax Model
class Tax {
  final int id;
  final String region;
  final String type;
  final double rate;

  Tax({
    required this.id,
    required this.region,
    required this.type,
    required this.rate,
  });

  Tax copyWith({String? region, String? type, double? rate}) {
    return Tax(
      id: id,
      region: region ?? this.region,
      type: type ?? this.type,
      rate: rate ?? this.rate,
    );
  }
}

// Main Tax Settings Page
class TaxSettingsPage extends StatefulWidget {
  const TaxSettingsPage({super.key});

  @override
  State<TaxSettingsPage> createState() => _TaxSettingsPageState();
}

class _TaxSettingsPageState extends State<TaxSettingsPage> {
  List<Tax> taxes = [
    Tax(id: 1, region: 'California', type: 'State Tax', rate: 7.25),
    Tax(id: 2, region: 'New York', type: 'State Tax', rate: 8.875),
    Tax(id: 3, region: 'Texas', type: 'State Tax', rate: 6.25),
    Tax(id: 4, region: 'VAT (EU)', type: 'Value Added Tax', rate: 20),
  ];

  bool pricesIncludeTax = false;
  bool autoCalculateTax = true;
  bool showTaxBreakdown = true;
  bool taxExemptOrders = false;

  int nextId = 5;

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addTax() async {
    final result = await showDialog<Tax>(
      context: context,
      builder: (context) => const TaxModal(),
    );

    if (result != null) {
      setState(() {
        taxes.add(Tax(
          id: nextId++,
          region: result.region,
          type: result.type,
          rate: result.rate,
        ));
      });
      _showNotification('Tax rate added successfully!');
    }
  }

  void _editTax(Tax tax) async {
    final result = await showDialog<Tax>(
      context: context,
      builder: (context) => TaxModal(tax: tax),
    );

    if (result != null) {
      setState(() {
        final index = taxes.indexWhere((t) => t.id == tax.id);
        if (index != -1) {
          taxes[index] = result;
        }
      });
      _showNotification('Tax rate updated successfully!');
    }
  }

  void _deleteTax(Tax tax) {
    setState(() {
      taxes.removeWhere((t) => t.id == tax.id);
    });
    _showNotification('Tax rate deleted successfully!');
  }

  double _calculateTax(double subtotal) {
    if (taxes.isNotEmpty) {
      return subtotal * (taxes.first.rate / 100);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    const subtotal = 100.00;
    final taxAmount = _calculateTax(subtotal);
    final total = subtotal + taxAmount;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tax Rates Section - WHITE 3D BOX
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tax Rates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _addTax,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6F00),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: const Color(0xFFFF6F00).withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add Tax Rate'),
                      ),
                    ],
                  ),
                ),
                // Grey cards inside white box
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: taxes.map((tax) => _buildTaxRateCard(tax)).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Tax Settings Section - WHITE 3D BOX
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Tax Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                // Grey cards inside white box
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      _buildSettingRow(
                        'Prices Include Tax',
                        'Display prices with tax included',
                        pricesIncludeTax,
                            (value) {
                          setState(() => pricesIncludeTax = value);
                          _showNotification(
                            value
                                ? 'Prices will now include tax'
                                : 'Prices will now exclude tax',
                          );
                        },
                      ),
                      _buildSettingRow(
                        'Auto-Calculate Tax',
                        'Automatically calculate tax based on location',
                        autoCalculateTax,
                            (value) {
                          setState(() => autoCalculateTax = value);
                          _showNotification(
                            value
                                ? 'Auto-calculate tax enabled'
                                : 'Auto-calculate tax disabled',
                          );
                        },
                      ),
                      _buildSettingRow(
                        'Show Tax Breakdown',
                        'Display detailed tax information at checkout',
                        showTaxBreakdown,
                            (value) {
                          setState(() => showTaxBreakdown = value);
                          _showNotification(
                            value
                                ? 'Tax breakdown will be shown'
                                : 'Tax breakdown will be hidden',
                          );
                        },
                      ),
                      _buildSettingRow(
                        'Tax Exempt Orders',
                        'Allow tax-exempt customer accounts',
                        taxExemptOrders,
                            (value) {
                          setState(() => taxExemptOrders = value);
                          _showNotification(
                            value
                                ? 'Tax exempt orders enabled'
                                : 'Tax exempt orders disabled',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tax Calculation Example - WHITE 3D BOX
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Calculation Example',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Preview how taxes are calculated',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildCalculationRow('Subtotal:', '\$${subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        _buildCalculationRow(
                          'Tax (${taxes.isNotEmpty ? taxes.first.rate.toStringAsFixed(2) : '0'}%):',
                          '\$${taxAmount.toStringAsFixed(2)}',
                          isOrange: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Color(0xFFFFB74D), thickness: 1),
                        ),
                        _buildCalculationRow(
                          'Total:',
                          '\$${total.toStringAsFixed(2)}',
                          isBold: true,
                        ),
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

  Widget _buildTaxRateCard(Tax tax) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tax.region,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tax.type,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Tax Rate: ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                    Text(
                      '${tax.rate}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF6F00),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _editTax(tax),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1976D2),
            ),
            child: const Text('Edit'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => _deleteTax(tax),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value, {bool isOrange = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isOrange ? const Color(0xFFFF6F00) : Colors.black,
          ),
        ),
      ],
    );
  }
}

// Tax Modal Dialog - WHITE 3D BOX
class TaxModal extends StatefulWidget {
  final Tax? tax;

  const TaxModal({super.key, this.tax});

  @override
  State<TaxModal> createState() => _TaxModalState();
}

class _TaxModalState extends State<TaxModal> {
  late TextEditingController regionController;
  late TextEditingController rateController;
  String selectedType = 'State Tax';

  final List<String> taxTypes = [
    'State Tax',
    'Value Added Tax',
    'Sales Tax',
    'GST',
  ];

  @override
  void initState() {
    super.initState();
    regionController = TextEditingController(text: widget.tax?.region ?? '');
    rateController = TextEditingController(
      text: widget.tax?.rate.toString() ?? '',
    );
    selectedType = widget.tax?.type ?? 'State Tax';
  }

  @override
  void dispose() {
    regionController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.tax == null ? 'Add Tax Rate' : 'Edit Tax Rate',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Region',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: regionController,
              decoration: InputDecoration(
                hintText: 'e.g., Florida',
                hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tax Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              items: taxTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Tax Rate (%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'e.g., 7.25',
                hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF757575),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (regionController.text.isEmpty ||
                        rateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                      return;
                    }

                    final rate = double.tryParse(rateController.text);
                    if (rate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid tax rate'),
                        ),
                      );
                      return;
                    }

                    final result = Tax(
                      id: widget.tax?.id ?? 0,
                      region: regionController.text,
                      type: selectedType,
                      rate: rate,
                    );

                    Navigator.pop(context, result);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F00),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFFFF6F00).withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(widget.tax == null ? 'Add Tax Rate' : 'Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}