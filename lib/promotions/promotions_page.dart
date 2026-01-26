import 'package:flutter/material.dart';
import 'coupons/coupon_list_page.dart';
import 'flash_sales/flash_sales_page.dart';
import 'banners/banner_list_page.dart';
import 'widgets/promotion_card.dart';

class PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Promotions & Discounts",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PromotionCard(
                  title: "Coupons",
                  icon: Icons.confirmation_number_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CouponListPage(),
                      ),
                    );
                  },
                ),
                PromotionCard(
                  title: "Flash Sales",
                  icon: Icons.flash_on_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashSalesPage(),
                      ),
                    );
                  },
                ),
                PromotionCard(
                  title: "Banners",
                  icon: Icons.image_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BannerListPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
