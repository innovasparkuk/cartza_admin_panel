import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cms_provider.dart';

class CmsEditPage extends StatefulWidget {
  final CmsPageModel? page;
  const CmsEditPage({super.key, this.page});

  @override
  State<CmsEditPage> createState() => _CmsEditPageState();
}

class _CmsEditPageState extends State<CmsEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.page?.title ?? "");
    _contentController = TextEditingController(text: widget.page?.content ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.page != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Page Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                hintText: "Write content here",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final provider = context.read<CmsProvider>();
                if (isEdit) {
                  await provider.updatePage(
                    widget.page!.id,
                    _titleController.text,
                    _contentController.text,
                    context,
                  );
                } else {
                  await provider.addPage(
                    _titleController.text,
                    _contentController.text,
                    context,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(isEdit ? "Update" : "Add"),
            ),
          ),
        ],
      ),
    );
  }
}

