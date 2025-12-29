import 'package:flutter/material.dart';

class AppColors {
  static const success = Color(0xFF28A745);
  static const primary = Color(0xFFFF6F00);
}

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final List<Map<String, String>> zones = [
    {
      'name': 'United States',
      'region': 'All states',
      'rate': '5.99',
      'free': '50.00',
    },
    {
      'name': 'Canada',
      'region': 'All provinces',
      'rate': '8.99',
      'free': '75.00',
    },
    {
      'name': 'Asia Pacific',
      'region': 'Selected countries',
      'rate': '15.99',
      'free': '125.00',
    },
  ];

  bool expressShipping = true;
  bool localPickup = false;
  bool internationalShipping = true;
  bool shippingInsurance = false;

  void showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void openZoneDialog({int? index}) {
    final isEdit = index != null;
    final zone = isEdit ? zones[index] : null;

    final nameController = TextEditingController(text: zone?['name'] ?? '');
    final regionController = TextEditingController(text: zone?['region'] ?? '');
    final rateController = TextEditingController(text: zone?['rate'] ?? '');
    final freeController = TextEditingController(text: zone?['free'] ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          constraints: const BoxConstraints(maxWidth: 500),
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
                isEdit ? 'Edit Shipping Zone' : 'Add Shipping Zone',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Zone Name', nameController, 'e.g., United States'),
              const SizedBox(height: 16),
              _buildTextField('Regions', regionController, 'e.g., All states'),
              const SizedBox(height: 16),
              _buildTextField('Shipping Cost (\$)', rateController, 'e.g., 5.99', TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Free Shipping Threshold (\$)', freeController, 'e.g., 50.00', TextInputType.number),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        showNotification('Operation cancelled');
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF757575),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Validation
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter zone name', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      if (regionController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter regions', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      if (rateController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter shipping cost', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // Check if rate is valid number
                      final rate = double.tryParse(rateController.text.trim());
                      if (rate == null || rate < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter valid shipping cost', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // Check if free threshold is valid number
                      final free = double.tryParse(freeController.text.trim());
                      if (free == null || free < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter valid free shipping threshold', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // Save changes
                      final zoneName = nameController.text.trim();

                      if (isEdit) {
                        zones[index] = {
                          'name': zoneName,
                          'region': regionController.text.trim(),
                          'rate': rateController.text.trim(),
                          'free': freeController.text.trim(),
                        };
                      } else {
                        zones.add({
                          'name': zoneName,
                          'region': regionController.text.trim(),
                          'rate': rateController.text.trim(),
                          'free': freeController.text.trim(),
                        });
                      }

                      Navigator.of(dialogContext).pop();

                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {});
                        showNotification(
                          isEdit
                              ? 'Zone "$zoneName" updated successfully'
                              : 'Zone "$zoneName" added successfully',
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(isEdit ? 'Save Changes' : 'Add Zone'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, [TextInputType? keyboardType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  void deleteZone(int index) {
    final name = zones[index]['name']!;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) => Dialog(
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
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete Zone',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete the zone "$name"? This action cannot be undone.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        showNotification('Deletion cancelled');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.red.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('No'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      zones.removeAt(index);
                      Navigator.of(dialogContext).pop();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {});
                        showNotification('Zone "$name" deleted successfully');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.green.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildZoneCard(Map<String, String> zone, int index) {
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      zone['region']!,
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => openZoneDialog(index: index),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                    ),
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => deleteZone(index),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Shipping Cost: ',
                style: TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 13,
                ),
              ),
              Text(
                '\$${zone['rate']}',
                style: const TextStyle(
                  color: Color(0xFFFF6F00),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                'Free Shipping: ',
                style: TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 13,
                ),
              ),
              Text(
                '\$${zone['free']}+',
                style: const TextStyle(
                  color: Color(0xFF28A745),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildToggle(String label, String description, bool value, Function(bool) onChanged) {
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
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shipping Zones Section
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
                        'Shipping Zones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => openZoneDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add Zone'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: zones.asMap().entries.map((entry) => buildZoneCard(entry.value, entry.key)).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Shipping Options Section
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
                    'Shipping Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      buildToggle(
                        'Enable Express Shipping',
                        'Offer expedited delivery options',
                        expressShipping,
                            (val) {
                          setState(() => expressShipping = val);
                          showNotification('Express Shipping ${val ? "enabled" : "disabled"}');
                        },
                      ),
                      buildToggle(
                        'Local Pickup',
                        'Allow customers to pick up orders locally',
                        localPickup,
                            (val) {
                          setState(() => localPickup = val);
                          showNotification('Local Pickup ${val ? "enabled" : "disabled"}');
                        },
                      ),
                      buildToggle(
                        'International Shipping',
                        'Ship to countries outside configured zones',
                        internationalShipping,
                            (val) {
                          setState(() => internationalShipping = val);
                          showNotification('International Shipping ${val ? "enabled" : "disabled"}');
                        },
                      ),
                      buildToggle(
                        'Shipping Insurance',
                        'Automatically include shipping insurance',
                        shippingInsurance,
                            (val) {
                          setState(() => shippingInsurance = val);
                          showNotification('Shipping Insurance ${val ? "enabled" : "disabled"}');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}