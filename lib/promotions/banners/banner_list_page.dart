import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'create_banner_page.dart';
import 'package:shopease_admin/BannerProvider.dart';

class BannerListPage extends StatefulWidget {
  @override
  State<BannerListPage> createState() => _BannerListPageState();
}

class _BannerListPageState extends State<BannerListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().loadBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t        = AppLocalizations.of(context)!;
    final provider = context.watch<BannerProvider>();
    final isDark   = Theme.of(context).brightness == Brightness.dark;

    // ── Theme-aware colors ──────────────────────────────────────
    final appBarBg  = isDark ? const Color(0xFF1E1E1E) : const Color(0xFF4CAF50);
    final pageBg    = isDark ? const Color(0xFF121212) : const Color(0xFFF4F6FA);
    final btnColor  = isDark ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(t.banners),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Add Banner button ─────────────────────────────
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateBannerPage()),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: Text(t.addBanner),
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),

            const SizedBox(height: 20),

            // ── Banner list ───────────────────────────────────
            provider.isLoading
                ? const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: provider.banners.length,
                itemBuilder: (_, index) {
                  return _bannerTile(provider.banners[index], t, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerTile(BannerModel banner, AppLocalizations t, bool isDark) {
    final provider = context.read<BannerProvider>();

    // ── Theme-aware card colors ─────────────────────────────────
    final cardBg      = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final titleColor  = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF212121);
    final subColor    = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.05);

    final statusColor = banner.active
        ? const Color(0xFF4CAF50)
        : const Color(0xFF9E9E9E);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // ── Banner image ────────────────────────────────────────
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            banner.imageUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.broken_image, color: subColor, size: 24),
            ),
          ),
        ),
        // ── Title ───────────────────────────────────────────────
        title: Text(
          banner.title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        // ── Status ──────────────────────────────────────────────
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(children: [
            Container(
              width: 7, height: 7,
              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              banner.active ? t.active : t.inactive,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        // ── Toggle + Delete ─────────────────────────────────────
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: banner.active,
              onChanged: (val) => provider.updateBanner(
                  banner.id, banner.title, banner.imageUrl, val, context),
              activeColor: const Color(0xFF4CAF50),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFF44336)),
              onPressed: () => provider.deleteBanner(banner.id, context),
            ),
          ],
        ),
      ),
    );
  }
}