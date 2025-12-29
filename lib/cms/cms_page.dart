import 'package:flutter/material.dart';
import 'cms_edit_page.dart';

class CmsPage extends StatefulWidget {
  const CmsPage({super.key});

  @override
  State<CmsPage> createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  final Map<String, String> cmsData = {
    "About Us":
    "We are an online marketplace offering a wide range of products with reliable service and secure checkout.",
    "Privacy Policy":
    "User data is collected only to process orders, improve services, and keep accounts secure.",
    "FAQs":
    "Answers to common questions about shopping, payments, and order tracking.",
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color:
      isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF5F7FA),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CMS",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: cmsData.keys.map((title) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? Colors.white10
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color:
                                theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cmsData[title]!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: isDark
                              ? Colors.white10
                              : const Color(0xFFE8F5E9),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF388E3C),
                        ),
                        label: Text(
                          "Edit",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF388E3C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          final updatedText = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CmsEditPage(
                                title: title,
                                content: cmsData[title]!,
                              ),
                            ),
                          );

                          if (updatedText != null) {
                            setState(() {
                              cmsData[title] = updatedText;
                            });
                            _success("Content updated");
                          }
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }
}
