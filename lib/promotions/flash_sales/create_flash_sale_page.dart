import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_admin/l10n/app_localizations.dart'; // ✅ Ek hi bar import
import 'flash_sale_model.dart';

class CreateFlashSalePage extends StatefulWidget {
  final FlashSale? sale;

  const CreateFlashSalePage({this.sale});

  @override
  State<CreateFlashSalePage> createState() => _CreateFlashSalePageState();
}

class _CreateFlashSalePageState extends State<CreateFlashSalePage> {
  late TextEditingController _titleController;
  late TextEditingController _discountController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.sale?.title ?? "");
    _discountController =
        TextEditingController(text: widget.sale?.discount.toString() ?? "");
    _startController =
        TextEditingController(text: widget.sale?.startTime ?? "");
    _endController =
        TextEditingController(text: widget.sale?.endTime ?? "");
  }

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      controller.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
        isDark ? theme.colorScheme.surface : const Color(0xFF4CAF50),
        title: Text(
          widget.sale == null ? t.createFlashSale : t.editFlashSale
            ,style: TextStyle(color: Colors.white)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field(t.saleTitle, _titleController, context),
            const SizedBox(height: 14),
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: t.discountPercentage,
                suffixText: "%",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _startController,
              readOnly: true,
              onTap: () => _pickDate(context, _startController),
              decoration: InputDecoration(
                labelText: t.startDate,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _endController,
              readOnly: true,
              onTap: () => _pickDate(context, _endController),
              decoration: InputDecoration(
                labelText: t.endDate,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                onPressed: () async {
                  if (_titleController.text.isEmpty ||
                      _discountController.text.isEmpty ||
                      _startController.text.isEmpty ||
                      _endController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("All fields are required"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final sale = FlashSale(
                    id: widget.sale?.id,
                    title: _titleController.text,
                    discount: int.parse(_discountController.text),
                    startTime: _startController.text,
                    endTime: _endController.text,
                    active: widget.sale?.active ?? true,
                  );

                  Navigator.pop(context, sale);
                },


                child: Text(widget.sale == null ? t.create : t.update,style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String label, TextEditingController c, BuildContext context) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}