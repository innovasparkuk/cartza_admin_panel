import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cms_provider.dart';
import 'cms_form_sheet.dart';

class CmsPage extends StatefulWidget {
  const CmsPage({super.key});

  @override
  State<CmsPage> createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CmsProvider>().loadPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CmsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CMS Pages"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: provider.pages.isEmpty
            ? const Center(child: Text("No pages found"))
            : ListView.builder(
          itemCount: provider.pages.length,
          itemBuilder: (context, index) {
            final page = provider.pages[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    page.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Edit"),
                        onPressed: () {
                          showCmsFormSheet(
                            context,
                            page: page,
                          );
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Page"),
                                content: const Text(
                                  "Are you sure you want to delete this page?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            provider.deletePage(page.id, context);
                          }
                        },

                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CAF50),
        onPressed: () {
          showCmsFormSheet(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
