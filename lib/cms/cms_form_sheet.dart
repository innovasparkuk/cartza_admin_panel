import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cms_provider.dart';

void showCmsFormSheet(
    BuildContext context, {
      CmsPageModel? page,
    }) {
  final isEdit = page != null;

  final titleController = TextEditingController(text: page?.title ?? "");
  final contentController = TextEditingController(text: page?.content ?? "");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? "Edit Page" : "Add Page",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Title Field (always editable)
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Page Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Content Field
            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Content",
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final provider = context.read<CmsProvider>();

                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Title cannot be empty')),
                    );
                    return;
                  }

                  if (isEdit) {
                    await provider.updatePage(
                      page!.id,
                      titleController.text.trim(),
                      contentController.text.trim(),
                      context,
                    );
                  } else {
                    await provider.addPage(
                      titleController.text.trim(),
                      contentController.text.trim(),
                      context,
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(isEdit ? "Update Page" : "Add Page"),
              ),
            ),
          ],
        ),
      );
    },
  );
}
