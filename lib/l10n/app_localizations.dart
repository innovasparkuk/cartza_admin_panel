import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @welcomeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Admin'**
  String get welcomeAdmin;

  /// No description provided for @pageUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Page is under development'**
  String get pageUnderDevelopment;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @activeProducts.
  ///
  /// In en, this message translates to:
  /// **'Active Products'**
  String get activeProducts;

  /// No description provided for @salesTrends.
  ///
  /// In en, this message translates to:
  /// **'Sales Trends'**
  String get salesTrends;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @revenueGrowthOverTime.
  ///
  /// In en, this message translates to:
  /// **'Revenue growth over time'**
  String get revenueGrowthOverTime;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get topCategories;

  /// No description provided for @salesDistributionByCategory.
  ///
  /// In en, this message translates to:
  /// **'Sales distribution by product category'**
  String get salesDistributionByCategory;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronics;

  /// No description provided for @fashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get fashion;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @ordersMenu.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersMenu;

  /// No description provided for @productsMenu.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsMenu;

  /// No description provided for @categoriesMenu.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesMenu;

  /// No description provided for @cmsMenu.
  ///
  /// In en, this message translates to:
  /// **'CMS'**
  String get cmsMenu;

  /// No description provided for @promotionsMenu.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotionsMenu;

  /// No description provided for @analyticsSection.
  ///
  /// In en, this message translates to:
  /// **'ANALYTICS'**
  String get analyticsSection;

  /// No description provided for @reportsMenu.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsMenu;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @systemSection.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get systemSection;

  /// No description provided for @settingsMenu.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenu;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Notification sent'**
  String get notificationSent;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @enableDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get enableDarkTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get urdu;

  /// No description provided for @switchAppAppearance.
  ///
  /// In en, this message translates to:
  /// **'Switch app appearance'**
  String get switchAppAppearance;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @banners.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get banners;

  /// No description provided for @addBanner.
  ///
  /// In en, this message translates to:
  /// **'Add Banner'**
  String get addBanner;

  /// No description provided for @summerSale.
  ///
  /// In en, this message translates to:
  /// **'Summer Sale'**
  String get summerSale;

  /// No description provided for @newArrivals.
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get newArrivals;

  /// No description provided for @createBanner.
  ///
  /// In en, this message translates to:
  /// **'Create Banner'**
  String get createBanner;

  /// No description provided for @bannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Banner Title'**
  String get bannerTitle;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @saveBanner.
  ///
  /// In en, this message translates to:
  /// **'Save Banner'**
  String get saveBanner;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @addCoupon.
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get addCoupon;

  /// No description provided for @couponAdded.
  ///
  /// In en, this message translates to:
  /// **'Coupon added'**
  String get couponAdded;

  /// No description provided for @noCouponsFound.
  ///
  /// In en, this message translates to:
  /// **'No coupons found'**
  String get noCouponsFound;

  /// No description provided for @deleteCoupon.
  ///
  /// In en, this message translates to:
  /// **'Delete Coupon'**
  String get deleteCoupon;

  /// No description provided for @deleteCouponConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this coupon?'**
  String get deleteCouponConfirmation;

  /// No description provided for @couponDeleted.
  ///
  /// In en, this message translates to:
  /// **'Coupon deleted'**
  String get couponDeleted;

  /// No description provided for @couponUpdated.
  ///
  /// In en, this message translates to:
  /// **'Coupon updated'**
  String get couponUpdated;

  /// No description provided for @createCoupon.
  ///
  /// In en, this message translates to:
  /// **'Create Coupon'**
  String get createCoupon;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @discountType.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get discountType;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @flat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get flat;

  /// No description provided for @discountValue.
  ///
  /// In en, this message translates to:
  /// **'Discount Value'**
  String get discountValue;

  /// No description provided for @saveCoupon.
  ///
  /// In en, this message translates to:
  /// **'Save Coupon'**
  String get saveCoupon;

  /// No description provided for @editCoupon.
  ///
  /// In en, this message translates to:
  /// **'Edit Coupon'**
  String get editCoupon;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @createFlashSale.
  ///
  /// In en, this message translates to:
  /// **'Create Flash Sale'**
  String get createFlashSale;

  /// No description provided for @editFlashSale.
  ///
  /// In en, this message translates to:
  /// **'Edit Flash Sale'**
  String get editFlashSale;

  /// No description provided for @saleTitle.
  ///
  /// In en, this message translates to:
  /// **'Sale Title'**
  String get saleTitle;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage'**
  String get discountPercentage;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @flashSaleCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Flash sale created successfully'**
  String get flashSaleCreatedSuccessfully;

  /// No description provided for @noActiveFlashSales.
  ///
  /// In en, this message translates to:
  /// **'No active flash sales'**
  String get noActiveFlashSales;

  /// No description provided for @flashSales.
  ///
  /// In en, this message translates to:
  /// **'Flash Sales'**
  String get flashSales;

  /// No description provided for @promotionsDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Discounts'**
  String get promotionsDiscounts;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @viewOrders.
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get viewOrders;

  /// No description provided for @sendAlert.
  ///
  /// In en, this message translates to:
  /// **'Send Alert'**
  String get sendAlert;

  /// No description provided for @topSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Products'**
  String get topSellingProducts;

  /// No description provided for @iphone14.
  ///
  /// In en, this message translates to:
  /// **'iPhone 14'**
  String get iphone14;

  /// No description provided for @runningShoes.
  ///
  /// In en, this message translates to:
  /// **'Running Shoes'**
  String get runningShoes;

  /// No description provided for @smartWatch.
  ///
  /// In en, this message translates to:
  /// **'Smart Watch'**
  String get smartWatch;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'sales'**
  String get sales;

  /// No description provided for @userGrowth.
  ///
  /// In en, this message translates to:
  /// **'User Growth'**
  String get userGrowth;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @aiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get aiRecommendations;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @generatingAiResponse.
  ///
  /// In en, this message translates to:
  /// **'Generating AI response'**
  String get generatingAiResponse;

  /// No description provided for @productRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Product Recommendations'**
  String get productRecommendations;

  /// No description provided for @salesAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Sales Analysis'**
  String get salesAnalysis;

  /// No description provided for @marketingStrategy.
  ///
  /// In en, this message translates to:
  /// **'Marketing Strategy'**
  String get marketingStrategy;

  /// No description provided for @customerInsights.
  ///
  /// In en, this message translates to:
  /// **'Customer Insights'**
  String get customerInsights;

  /// No description provided for @inventoryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Inventory Optimization'**
  String get inventoryOptimization;

  /// No description provided for @usingFreeAiProxies.
  ///
  /// In en, this message translates to:
  /// **'Using free public AI proxies'**
  String get usingFreeAiProxies;

  /// No description provided for @noApiKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'No API key required'**
  String get noApiKeyRequired;

  /// No description provided for @aiGenerated.
  ///
  /// In en, this message translates to:
  /// **'AI Generated'**
  String get aiGenerated;

  /// No description provided for @freeService.
  ///
  /// In en, this message translates to:
  /// **'100% Free'**
  String get freeService;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @stockUnits.
  ///
  /// In en, this message translates to:
  /// **'Stock Units'**
  String get stockUnits;

  /// No description provided for @generateInsights.
  ///
  /// In en, this message translates to:
  /// **'Generate Insights'**
  String get generateInsights;

  /// No description provided for @temporaryIssue.
  ///
  /// In en, this message translates to:
  /// **'Temporary issue with AI service'**
  String get temporaryIssue;

  /// No description provided for @fallbackRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Fallback recommendations'**
  String get fallbackRecommendations;

  /// No description provided for @aiPoweredInsights.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Insights'**
  String get aiPoweredInsights;

  /// No description provided for @getSmartRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get smart recommendations'**
  String get getSmartRecommendations;

  /// No description provided for @analyzeSalesData.
  ///
  /// In en, this message translates to:
  /// **'Analyze sales data'**
  String get analyzeSalesData;

  /// No description provided for @generateAdCopy.
  ///
  /// In en, this message translates to:
  /// **'Generate ad copy'**
  String get generateAdCopy;

  /// No description provided for @analyzeCustomerBehavior.
  ///
  /// In en, this message translates to:
  /// **'Analyze customer behavior'**
  String get analyzeCustomerBehavior;

  /// No description provided for @optimizeInventoryLevels.
  ///
  /// In en, this message translates to:
  /// **'Optimize inventory levels'**
  String get optimizeInventoryLevels;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
