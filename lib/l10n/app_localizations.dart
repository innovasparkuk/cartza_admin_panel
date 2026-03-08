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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ShopEase Admin'**
  String get appTitle;

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

  /// No description provided for @analyticsMenu.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsMenu;

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

  /// No description provided for @customersMenu.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersMenu;

  /// No description provided for @paymentsMenu.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsMenu;

  /// No description provided for @reviewsMenu.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsMenu;

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
  /// **'Urdu'**
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

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @orderAge.
  ///
  /// In en, this message translates to:
  /// **'Order Age'**
  String get orderAge;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changeStatus;

  /// No description provided for @deleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Delete Order'**
  String get deleteOrder;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @areYouSureDeleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete order'**
  String get areYouSureDeleteOrder;

  /// No description provided for @orderStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order status updated to'**
  String get orderStatusUpdated;

  /// No description provided for @orderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Order deleted successfully'**
  String get orderDeleted;

  /// No description provided for @errorLoadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get errorLoadingOrders;

  /// No description provided for @errorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error updating status'**
  String get errorUpdatingStatus;

  /// No description provided for @errorDeletingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error deleting order'**
  String get errorDeletingOrder;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @searchOrdersByIdOrCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search orders by ID or customer...'**
  String get searchOrdersByIdOrCustomer;

  /// No description provided for @customerManagement.
  ///
  /// In en, this message translates to:
  /// **'Customer Management'**
  String get customerManagement;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get totalCustomers;

  /// No description provided for @activeCustomers.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeCustomers;

  /// No description provided for @inactiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveCustomers;

  /// No description provided for @blockedCustomers.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blockedCustomers;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers...'**
  String get searchCustomers;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @customerAge.
  ///
  /// In en, this message translates to:
  /// **'Customer Age'**
  String get customerAge;

  /// No description provided for @lastActive.
  ///
  /// In en, this message translates to:
  /// **'Last Active'**
  String get lastActive;

  /// No description provided for @customerTimeline.
  ///
  /// In en, this message translates to:
  /// **'Customer Timeline'**
  String get customerTimeline;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @ordersPlaced.
  ///
  /// In en, this message translates to:
  /// **'orders placed'**
  String get ordersPlaced;

  /// No description provided for @unblockCustomer.
  ///
  /// In en, this message translates to:
  /// **'Unblock Customer'**
  String get unblockCustomer;

  /// No description provided for @blockCustomer.
  ///
  /// In en, this message translates to:
  /// **'Block Customer'**
  String get blockCustomer;

  /// No description provided for @sendPromotion.
  ///
  /// In en, this message translates to:
  /// **'Send Promotion'**
  String get sendPromotion;

  /// No description provided for @promotionSent.
  ///
  /// In en, this message translates to:
  /// **'Promotion sent to'**
  String get promotionSent;

  /// No description provided for @customerBlocked.
  ///
  /// In en, this message translates to:
  /// **'Customer blocked successfully'**
  String get customerBlocked;

  /// No description provided for @customerUnblocked.
  ///
  /// In en, this message translates to:
  /// **'Customer unblocked successfully'**
  String get customerUnblocked;

  /// No description provided for @errorLoadingCustomers.
  ///
  /// In en, this message translates to:
  /// **'Error loading customers'**
  String get errorLoadingCustomers;

  /// No description provided for @sendPromotionalEmail.
  ///
  /// In en, this message translates to:
  /// **'Send promotional email to'**
  String get sendPromotionalEmail;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @confirmBlock.
  ///
  /// In en, this message translates to:
  /// **'Confirm Block'**
  String get confirmBlock;

  /// No description provided for @confirmUnblock.
  ///
  /// In en, this message translates to:
  /// **'Confirm Unblock'**
  String get confirmUnblock;

  /// No description provided for @productManagement.
  ///
  /// In en, this message translates to:
  /// **'Product Management'**
  String get productManagement;

  /// No description provided for @stockManagement.
  ///
  /// In en, this message translates to:
  /// **'Stock Management'**
  String get stockManagement;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProducts;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteProductConfirmation;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted'**
  String get productDeleted;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productUpdated;

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added'**
  String get productAdded;

  /// No description provided for @bulkUpload.
  ///
  /// In en, this message translates to:
  /// **'Bulk upload'**
  String get bulkUpload;

  /// No description provided for @csvUploadComingSoon.
  ///
  /// In en, this message translates to:
  /// **'CSV upload coming soon'**
  String get csvUploadComingSoon;

  /// No description provided for @categoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// No description provided for @manageProductCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage your product categories'**
  String get manageProductCategories;

  /// No description provided for @totalCategories.
  ///
  /// In en, this message translates to:
  /// **'Total Categories'**
  String get totalCategories;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProducts;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @subcategoryName.
  ///
  /// In en, this message translates to:
  /// **'Subcategory Name'**
  String get subcategoryName;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'Product Count'**
  String get productCount;

  /// No description provided for @imageSource.
  ///
  /// In en, this message translates to:
  /// **'Image Source'**
  String get imageSource;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @assetsFolder.
  ///
  /// In en, this message translates to:
  /// **'Assets Folder'**
  String get assetsFolder;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @selectImageFromAssets.
  ///
  /// In en, this message translates to:
  /// **'Select Image from Assets'**
  String get selectImageFromAssets;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get pleaseEnter;

  /// No description provided for @validNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get validNumber;

  /// No description provided for @addSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add Subcategory'**
  String get addSubcategory;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm?'**
  String get confirmDelete;

  /// No description provided for @sub.
  ///
  /// In en, this message translates to:
  /// **'Sub'**
  String get sub;

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully'**
  String get imageUploaded;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get imageUploadFailed;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated!'**
  String get categoryUpdated;

  /// No description provided for @categoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Category added!'**
  String get categoryAdded;

  /// No description provided for @subcategoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Subcategory added successfully!'**
  String get subcategoryAdded;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully!'**
  String get categoryDeleted;

  /// No description provided for @pleaseEnterSubcategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter subcategory name'**
  String get pleaseEnterSubcategoryName;
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
