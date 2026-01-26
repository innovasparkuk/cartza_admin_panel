import 'package:flutter/material.dart';
import 'tax.dart';

class TaxModal extends StatefulWidget {
  final Tax? tax;
  const TaxModal({this.tax, super.key});

  @override
  State<TaxModal> createState() => _TaxModalState();
}

class _TaxModalState extends State<TaxModal> {
  String _region = allRegions.first;
  String _type = allTaxTypes.first;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _region = widget.tax?.region ?? allRegions.first;
    _type = widget.tax?.type ?? allTaxTypes.first;
    _rateController = TextEditingController(
        text: widget.tax != null ? widget.tax!.rate.toString() : '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tax == null ? 'Add Tax' : 'Edit Tax'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _region,
              items: allRegions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => _region = val!),
              decoration: const InputDecoration(labelText: 'Region'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _type,
              items: allTaxTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) => setState(() => _type = val!),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rate (%)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Tax newTax = Tax(
              id: widget.tax?.id ?? DateTime.now().millisecondsSinceEpoch,
              region: _region,
              type: _type,
              rate: double.tryParse(_rateController.text) ?? 0,
            );
            Navigator.pop(context, newTax);
          },
          child: const Text('Save'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6F00)),
        ),
      ],
    );
  }
}
