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
    final t = AppLocalizations.of(context)!;
    final provider = context.watch<BannerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.banners),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateBannerPage()),
              ),
              child: Text(t.addBanner),
            ),
            const SizedBox(height: 20),
            provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: provider.banners.length,
                itemBuilder: (_, index) {
                  final banner = provider.banners[index];
                  return _bannerTile(banner, t);
                },
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _bannerTile(BannerModel banner, AppLocalizations t) {
    final provider = context.read<BannerProvider>();
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Image.network(banner.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          banner.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          banner.active ? t.active : t.inactive,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: banner.active,
              onChanged: (val) =>
                  provider.updateBanner(banner.id, banner.title, banner.imageUrl, val, context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => provider.deleteBanner(banner.id, context),
            ),
          ],
        ),
      ),
    );

  }
}
