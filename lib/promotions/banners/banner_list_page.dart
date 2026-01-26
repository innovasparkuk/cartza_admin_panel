import 'package:flutter/material.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import 'create_banner_page.dart';

class BannerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.banners),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateBannerPage(),
                  ),
                );
              },
              child: Text(t.addBanner,style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4CAF50)),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _bannerTile(t.summerSale, true, t),
                  _bannerTile(t.newArrivals, false, t),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerTile(String title, bool active, AppLocalizations t) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.image),
        title: Text(title),
        subtitle: Text(active ? t.active : t.inactive),
        trailing: Switch(
          value: active,
          onChanged: (val) {},
        ),
      ),
    );
  }
}