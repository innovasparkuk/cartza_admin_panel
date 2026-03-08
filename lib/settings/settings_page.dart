import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_admin/l10n/app_localizations.dart';
import '../theme/theme_provider.dart';
import '../theme/locale_provider.dart';

class AppColors {
  static const primary      = Color(0xFFFF6F00);
  static const primaryHover = Color(0xFFF57C00);
  static const success      = Color(0xFF4CAF50);
  static const danger       = Color(0xFFF44336);

  static const dark      = Color(0xFF212121);
  static const grey      = Color(0xFF9E9E9E);
  static const lightGrey = Color(0xFFE0E0E0);
  static const bg        = Color(0xFFF4F6FA);
}

extension DynColors on BuildContext {
  bool get _dark => Theme.of(this).brightness == Brightness.dark;

  Color get cardBg        => _dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get sectionBg     => _dark ? const Color(0xFF1A1A1A) : Colors.white;
  Color get pageBg        => _dark ? const Color(0xFF121212) : const Color(0xFFF4F6FA);
  Color get tabBarBg      => _dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get inputFill     => _dark ? const Color(0xFF2C2C2C) : const Color(0xFFFAFAFA);
  Color get inputBorder   => _dark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0);
  Color get textPrimary   => _dark ? const Color(0xFFF5F5F5) : const Color(0xFF212121);
  Color get textSecondary => _dark ? const Color(0xFF9E9E9E) : const Color(0xFF9E9E9E);
  Color get dividerColor  => _dark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
  Color get chipBg        => _dark ? const Color(0xFF2C2C2C) : const Color(0xFFF4F6FA);
  Color get shadowColor   => _dark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.06);
  Color get fieldLabelColor => _dark ? const Color(0xFFCCCCCC) : const Color(0xFF424242);
  Color get dangerBg      => _dark ? const Color(0xFF2D1515) : const Color(0xFFFFEBEE);
  Color get infoBg        => _dark ? const Color(0xFF1A2A1A) : const Color(0xFFE8F5E9);
  Color get warnBg        => _dark ? const Color(0xFF2A2000) : const Color(0xFFFFF8E1);
  Color get blueBg        => _dark ? const Color(0xFF0D1A2A) : const Color(0xFFE3F2FD);
  Color get blueInfoBg    => _dark ? const Color(0xFF0D1520) : const Color(0xFFE3F2FD);
  Color get previewBg     => _dark ? const Color(0xFF1A1200) : const Color(0xFFFFF8F0);
  Color get popupBg       => _dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get borderSubtle  => _dark ? const Color(0xFF2A2A2A) : Colors.grey.withOpacity(0.08);
  // Branding-specific
  Color get brandingPreviewBg  => _dark ? const Color(0xFF222222) : const Color(0xFFFAF9F7);
  Color get brandingPrimaryFill => _dark ? const Color(0xFF2A1A00) : const Color(0xFFFFFBF5);
}

// ─────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────
class TeamMember {
  final int id;
  final String name, email, role, status, joinDate;
  TeamMember({required this.id, required this.name, required this.email,
    required this.role, required this.status, required this.joinDate});
}
final List<String> allRoles    = ['Admin', 'Manager', 'Editor', 'Viewer'];
final List<String> allStatuses = ['Active', 'Inactive', 'Pending'];

class Tax {
  final int id;
  final String region, type;
  final double rate;
  Tax({required this.id, required this.region, required this.type, required this.rate});
}

class Permission {
  final String id, label, description;
  Permission({required this.id, required this.label, required this.description});
}

final List<Permission> allPermissions = [
  Permission(id: 'read',            label: 'Read Content',    description: 'View and read content without making changes'),
  Permission(id: 'write',           label: 'Write Content',   description: 'Create and edit content'),
  Permission(id: 'delete',          label: 'Delete Content',  description: 'Remove content permanently'),
  Permission(id: 'manage_users',    label: 'Manage Users',    description: 'Add, edit, and remove users'),
  Permission(id: 'manage_settings', label: 'Manage Settings', description: 'Configure system settings'),
  Permission(id: 'view_reports',    label: 'View Reports',    description: 'Access analytics and reports'),
  Permission(id: 'export_data',     label: 'Export Data',     description: 'Export data to external formats'),
  Permission(id: 'manage_billing',  label: 'Manage Billing',  description: 'Handle billing and payments'),
];

class Role {
  final int id;
  final String name, description;
  final List<String> permissions;
  Role({required this.id, required this.name, required this.description, required this.permissions});
}

class Session {
  final String device, location, ip, time;
  final bool isCurrentSession;
  Session({required this.device, required this.location, required this.ip,
    required this.time, this.isCurrentSession = false});
}

class LoginHistory {
  final String device, location, time;
  final bool isSuccessful;
  LoginHistory({required this.device, required this.location,
    required this.time, this.isSuccessful = true});
}

// ─────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'General',  'icon': Icons.tune},
    {'label': 'Branding', 'icon': Icons.layers},
    {'label': 'Shipping', 'icon': Icons.local_shipping},
    {'label': 'Roles',    'icon': Icons.security},
    {'label': 'Team',     'icon': Icons.people},
    {'label': 'Taxes',    'icon': Icons.attach_money},
    {'label': 'Security', 'icon': Icons.lock},
  ];

  @override
  void initState() { super.initState(); _tab = TabController(length: _tabs.length, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: context.tabBarBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: context.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: TabBar(
          controller: _tab,
          isScrollable: true,
          padding: const EdgeInsets.all(6),
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.grey,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: _tabs.map((t) => Tab(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(t['icon'] as IconData, size: 16),
                const SizedBox(width: 7),
                Text(t['label'] as String),
              ]),
            ),
          )).toList(),
        ),
      ),
      const SizedBox(height: 20),
      Expanded(
        child: TabBarView(
          controller: _tab,
          children: const [
            _GeneralTab(),
            _BrandingTab(),  // ← Branding fully integrated here
            _ShippingTab(),
            _RolesTab(),
            _TeamTab(),
            _TaxTab(),
            _SecurityTab(),
          ],
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  SHARED HELPERS
// ─────────────────────────────────────────────
Widget _card(BuildContext ctx, {required Widget child, Color? bg, EdgeInsets? padding}) =>
    Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg ?? ctx.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: ctx.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: ctx.borderSubtle),
      ),
      child: child,
    );

Widget _section(BuildContext ctx, {required String title, required Widget child}) =>
    Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: ctx.sectionBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: ctx.shadowColor, blurRadius: 10, offset: const Offset(0, 3))],
        border: Border.all(color: ctx.borderSubtle),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Row(children: [
            Container(width: 3, height: 18, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ctx.textPrimary)),
          ]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 20, color: ctx.dividerColor)),
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), child: child),
      ]),
    );

Widget _toggleCard(BuildContext ctx, String title, String sub, bool val, Function(bool) cb, {IconData? icon}) =>
    _card(ctx, child: Row(children: [
      if (icon != null) ...[
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.primary, size: 18)),
        const SizedBox(width: 14),
      ],
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ctx.textPrimary)),
        const SizedBox(height: 3),
        Text(sub, style: TextStyle(fontSize: 12, color: ctx.textSecondary)),
      ])),
      Switch(value: val, onChanged: cb, activeColor: AppColors.success),
    ]));

void _toast(BuildContext ctx, String msg, {bool error = false}) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: error ? AppColors.danger : AppColors.success,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: const EdgeInsets.all(16),
  ));
}

InputDecoration _inputDec(BuildContext ctx, String hint, {Color? fillOverride}) => InputDecoration(
  hintText: hint,
  hintStyle: TextStyle(color: ctx.textSecondary, fontSize: 13),
  filled: true,
  fillColor: fillOverride ?? ctx.inputFill,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border:        OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ctx.inputBorder)),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ctx.inputBorder)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.8)),
);

Widget _fieldLabel(BuildContext ctx, String t) => Padding(
  padding: const EdgeInsets.only(bottom: 7),
  child: Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ctx.fieldLabelColor)),
);

Widget _scrollView(Widget child) => SingleChildScrollView(padding: const EdgeInsets.only(bottom: 32), child: child);

Widget _actionBtn(String label, Color color, VoidCallback onTap) => TextButton(
  onPressed: onTap,
  style: TextButton.styleFrom(foregroundColor: color, minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 10)),
  child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
);

Widget _popupBtn(BuildContext ctx, IconData icon, String label, List<String> opts, void Function(String) onSel) =>
    PopupMenuButton<String>(
      onSelected: onSel,
      color: ctx.popupBg,
      itemBuilder: (_) => opts.map((o) => PopupMenuItem(value: o,
          child: Text(o, style: TextStyle(fontSize: 13, color: ctx.textPrimary)))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ctx.cardBg, borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ctx.inputBorder),
          boxShadow: [BoxShadow(color: ctx.shadowColor, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: ctx.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, color: ctx.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 15, color: ctx.textSecondary),
        ]),
      ),
    );

Widget _chip(String val, String lbl, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  decoration: BoxDecoration(
    color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6),
    border: Border.all(color: color.withOpacity(0.3)),
  ),
  child: RichText(text: TextSpan(children: [
    TextSpan(text: '$lbl: ', style: TextStyle(fontSize: 11, color: color.withOpacity(0.8), fontWeight: FontWeight.w500)),
    TextSpan(text: val, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
  ])),
);

Widget _dialogHeader(BuildContext ctx, String title, IconData icon) => Row(children: [
  Container(width: 38, height: 38,
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: AppColors.primary, size: 18)),
  const SizedBox(width: 12),
  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ctx.textPrimary)),
]);

Widget _dialogActions(BuildContext ctx, String confirmLabel, VoidCallback onConfirm) =>
    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      OutlinedButton(
        onPressed: () => Navigator.pop(ctx),
        style: OutlinedButton.styleFrom(
          foregroundColor: ctx.textSecondary,
          side: BorderSide(color: ctx.inputBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Cancel'),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(confirmLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    ]);

Widget _dialogBox(BuildContext ctx, {required double width, required Widget child}) =>
    Dialog(
      backgroundColor: ctx.sectionBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ctx.sectionBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: child,
      ),
    );

// ─────────────────────────────────────────────
//  1. GENERAL TAB
// ─────────────────────────────────────────────
class _GeneralTab extends StatelessWidget {
  const _GeneralTab();

  @override
  Widget build(BuildContext context) {
    final theme  = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>();
    final t      = AppLocalizations.of(context)!;

    return _scrollView(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _section(context, title: 'Appearance', child: Column(children: [
        _toggleCard(context, t.darkMode, t.enableDarkTheme, theme.isDark, theme.setTheme, icon: Icons.dark_mode),
      ])),
      _section(context, title: 'Language & Region', child: Column(children: [
        _card(context, child: Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.language, color: AppColors.primary, size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.language, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary)),
            Text(t.selectLanguage, style: TextStyle(fontSize: 12, color: context.textSecondary)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: context.inputBorder),
              borderRadius: BorderRadius.circular(8),
              color: context.inputFill,
            ),
            child: DropdownButtonHideUnderline(child: DropdownButton<Locale>(
              value: locale.locale, isDense: true,
              dropdownColor: context.popupBg,
              style: TextStyle(fontSize: 13, color: context.textPrimary, fontWeight: FontWeight.w500),
              onChanged: (l) { if (l != null) locale.setLocale(l); },
              items: [
                DropdownMenuItem(value: const Locale('en'), child: Text(t.english)),
                DropdownMenuItem(value: const Locale('ur'), child: Text(t.urdu)),
              ],
            )),
          ),
        ])),
      ])),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withOpacity(0.25)),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text('Changes to appearance and language take effect immediately.',
              style: TextStyle(fontSize: 13, color: AppColors.primary.withOpacity(0.9)))),
        ]),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────
//  2. BRANDING TAB  (fully integrated, no separate file)
// ─────────────────────────────────────────────
class _BrandingTab extends StatefulWidget {
  const _BrandingTab();
  @override
  State<_BrandingTab> createState() => _BrandingTabState();
}

class _BrandingTabState extends State<_BrandingTab> {
  final _companyNameCtrl = TextEditingController(text: 'InnovaSpark');
  final _taglineCtrl     = TextEditingController(text: 'Innovation for Tomorrow');
  final _logoUrlCtrl     = TextEditingController(text: 'https://via.placeholder.com/150x50?text=Logo');
  final _primaryCtrl     = TextEditingController(text: '#FF6F00');
  final _secondaryCtrl   = TextEditingController(text: '#212121');
  final _accentCtrl      = TextEditingController(text: '#4CAF50');

  Color _primaryColor   = const Color(0xFFFF6F00);
  Color _secondaryColor = const Color(0xFF212121);
  Color _accentColor    = const Color(0xFF4CAF50);

  @override
  void dispose() {
    _companyNameCtrl.dispose(); _taglineCtrl.dispose(); _logoUrlCtrl.dispose();
    _primaryCtrl.dispose(); _secondaryCtrl.dispose(); _accentCtrl.dispose();
    super.dispose();
  }

  void _resetToDefault() {
    setState(() {
      _primaryColor   = const Color(0xFFFF6F00);
      _secondaryColor = const Color(0xFF212121);
      _accentColor    = const Color(0xFF4CAF50);
      _primaryCtrl.text   = '#FF6F00';
      _secondaryCtrl.text = '#212121';
      _accentCtrl.text    = '#4CAF50';
    });
    _toast(context, 'Colors reset to default values');
  }

  @override
  Widget build(BuildContext context) {
    return _scrollView(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // ── Company Information ─────────────────────────────────
      _section(context, title: 'Company Information', child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(context, 'Company Name'),
          TextField(
            controller: _companyNameCtrl,
            onChanged: (_) => setState(() {}),
            style: TextStyle(fontSize: 13, color: context.textPrimary),
            decoration: _inputDec(context, 'e.g., InnovaSpark',
                fillOverride: context.brandingPrimaryFill).copyWith(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.6), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _fieldLabel(context, 'Tagline'),
          TextField(
            controller: _taglineCtrl,
            onChanged: (_) => setState(() {}),
            style: TextStyle(fontSize: 13, color: context.textPrimary),
            decoration: _inputDec(context, 'e.g., Innovation for Tomorrow'),
          ),
          const SizedBox(height: 16),
          _fieldLabel(context, 'Company Logo URL'),
          TextField(
            controller: _logoUrlCtrl,
            style: TextStyle(fontSize: 13, color: context.textPrimary),
            decoration: _inputDec(context, 'https://...'),
          ),
          const SizedBox(height: 6),
          Text('Recommended size: 400x100 pixels',
              style: TextStyle(fontSize: 12, color: context.textSecondary)),
        ],
      )),

      // ── Brand Colors ────────────────────────────────────────
      _section(context, title: 'Brand Colors', child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _colorPicker(context, 'Primary Color',   _primaryColor,   _primaryCtrl)),
            const SizedBox(width: 16),
            Expanded(child: _colorPicker(context, 'Secondary Color', _secondaryColor, _secondaryCtrl)),
            const SizedBox(width: 16),
            Expanded(child: _colorPicker(context, 'Accent Color',    _accentColor,    _accentCtrl)),
          ]),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
              onPressed: _resetToDefault,
              style: TextButton.styleFrom(
                foregroundColor: context.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Reset to Default',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _toast(context, 'Changes saved successfully!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Save Changes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ]),
        ],
      )),

      // ── Preview ─────────────────────────────────────────────
      _section(context, title: 'Preview', child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('See how your branding looks',
              style: TextStyle(fontSize: 13, color: context.textSecondary)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              // ── Dark mode aware preview background ──
              color: context.brandingPreviewBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.borderSubtle),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                _companyNameCtrl.text.isEmpty ? 'Company Name' : _companyNameCtrl.text,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryColor),
              ),
              const SizedBox(height: 6),
              Text(
                _taglineCtrl.text.isEmpty ? 'Your tagline here' : _taglineCtrl.text,
                style: TextStyle(fontSize: 13, color: context.textSecondary),
              ),
              const SizedBox(height: 20),
              Wrap(spacing: 10, runSpacing: 10, children: [
                _previewBtn('Primary Button',   _primaryColor),
                _previewBtn('Secondary Button', _secondaryColor),
                _previewBtn('Accent Button',    _accentColor),
              ]),
            ]),
          ),
        ],
      )),

    ]));
  }

  // Color picker row: swatch + hex input
  Widget _colorPicker(BuildContext ctx, String label, Color color, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fieldLabel(ctx, label),
      Container(
        decoration: BoxDecoration(
          color: ctx.cardBg,
          border: Border.all(color: ctx.inputBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          // Color swatch
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7), bottomLeft: Radius.circular(7),
              ),
            ),
          ),
          // Hex input
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: ctrl,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'monospace', color: ctx.textPrimary),
              decoration: const InputDecoration(
                border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
              ),
            ),
          )),
        ]),
      ),
    ]);
  }

  Widget _previewBtn(String label, Color color) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 0,
    ),
    child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
  );
}

// ─────────────────────────────────────────────
//  3. SHIPPING TAB
// ─────────────────────────────────────────────
class _ShippingTab extends StatefulWidget {
  const _ShippingTab();
  @override
  State<_ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<_ShippingTab> {
  final List<Map<String, String>> zones = [
    {'name': 'United States', 'region': 'All states',         'rate': '5.99',  'free': '50.00'},
    {'name': 'Canada',        'region': 'All provinces',      'rate': '8.99',  'free': '75.00'},
    {'name': 'Asia Pacific',  'region': 'Selected countries', 'rate': '15.99', 'free': '125.00'},
  ];
  bool _express = true, _pickup = false, _intl = true, _ins = false;

  void _openDialog({int? idx}) {
    final isEdit = idx != null;
    final z  = isEdit ? zones[idx] : null;
    final nc = TextEditingController(text: z?['name']   ?? '');
    final rc = TextEditingController(text: z?['region'] ?? '');
    final rt = TextEditingController(text: z?['rate']   ?? '');
    final fc = TextEditingController(text: z?['free']   ?? '');
    showDialog(
      context: context, barrierColor: Colors.black54,
      builder: (ctx) => _ZoneDialog(isEdit: isEdit, nc: nc, rc: rc, rt: rt, fc: fc,
        onSave: () {
          if (nc.text.isEmpty || rc.text.isEmpty || rt.text.isEmpty || fc.text.isEmpty) return;
          final name = nc.text.trim();
          if (isEdit) zones[idx] = {'name': name, 'region': rc.text.trim(), 'rate': rt.text.trim(), 'free': fc.text.trim()};
          else zones.add({'name': name, 'region': rc.text.trim(), 'rate': rt.text.trim(), 'free': fc.text.trim()});
          Navigator.pop(ctx);
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {});
            _toast(context, isEdit ? 'Zone updated!' : 'Zone added!');
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _scrollView(Column(children: [
    _section(context, title: 'Shipping Zones', child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton.icon(onPressed: () => _openDialog(),
            icon: const Icon(Icons.add, size: 15), label: const Text('Add Zone'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      ]),
      const SizedBox(height: 12),
      ...zones.asMap().entries.map((e) => _zoneCard(context, e.value, e.key)),
    ])),
    _section(context, title: 'Shipping Options', child: Column(children: [
      _toggleCard(context, 'Enable Express Shipping', 'Offer expedited delivery', _express, (v) { setState(() => _express = v); _toast(context, 'Express ${v?"on":"off"}'); }, icon: Icons.flash_on),
      _toggleCard(context, 'Local Pickup',            'Allow local order pickup',  _pickup,  (v) { setState(() => _pickup = v);  _toast(context, 'Local pickup ${v?"on":"off"}'); }, icon: Icons.store),
      _toggleCard(context, 'International Shipping',  'Ship outside zones',        _intl,    (v) { setState(() => _intl = v);    _toast(context, 'International ${v?"on":"off"}'); }, icon: Icons.public),
      _toggleCard(context, 'Shipping Insurance',      'Include auto insurance',    _ins,     (v) { setState(() => _ins = v);     _toast(context, 'Insurance ${v?"on":"off"}'); }, icon: Icons.verified_user),
    ])),
  ]));

  Widget _zoneCard(BuildContext ctx, Map<String, String> z, int i) =>
      _card(ctx, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(z['name']!,   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: ctx.textPrimary)),
            Text(z['region']!, style: TextStyle(color: ctx.textSecondary, fontSize: 12)),
          ])),
          Row(children: [
            _actionBtn('Edit',   const Color(0xFF1976D2), () => _openDialog(idx: i)),
            const SizedBox(width: 4),
            _actionBtn('Delete', AppColors.danger, () { final n = z['name']!; zones.removeAt(i); setState(() {}); _toast(ctx, 'Zone "$n" deleted.'); }),
          ]),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _chip('\$${z['rate']}',  'Cost',      AppColors.primary),
          const SizedBox(width: 12),
          _chip('\$${z['free']}+', 'Free from', AppColors.success),
        ]),
      ]));
}

class _ZoneDialog extends StatelessWidget {
  final bool isEdit;
  final TextEditingController nc, rc, rt, fc;
  final VoidCallback onSave;
  const _ZoneDialog({required this.isEdit, required this.nc, required this.rc, required this.rt, required this.fc, required this.onSave});

  Widget _f(BuildContext ctx, String lbl, TextEditingController c, String hint, [TextInputType? kt]) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _fieldLabel(ctx, lbl),
        TextField(controller: c, keyboardType: kt, decoration: _inputDec(ctx, hint),
            style: TextStyle(fontSize: 13, color: ctx.textPrimary)),
        const SizedBox(height: 14),
      ]);

  @override
  Widget build(BuildContext context) => _dialogBox(context, width: 460,
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _dialogHeader(context, isEdit ? 'Edit Shipping Zone' : 'Add Shipping Zone', Icons.local_shipping),
      const SizedBox(height: 20),
      _f(context, 'Zone Name', nc, 'e.g., United States'),
      _f(context, 'Regions', rc, 'e.g., All states'),
      _f(context, 'Shipping Cost (\$)', rt, 'e.g., 5.99', TextInputType.number),
      _f(context, 'Free Shipping Threshold (\$)', fc, 'e.g., 50.00', TextInputType.number),
      _dialogActions(context, isEdit ? 'Save Changes' : 'Add Zone', onSave),
    ]),
  );
}

// ─────────────────────────────────────────────
//  4. ROLES TAB
// ─────────────────────────────────────────────
class _RolesTab extends StatefulWidget {
  const _RolesTab();
  @override
  State<_RolesTab> createState() => _RolesTabState();
}

class _RolesTabState extends State<_RolesTab> {
  List<Role> roles = [
    Role(id: 1, name: 'Admin',   description: 'Full system access',          permissions: ['read','write','delete','manage_users','manage_settings','view_reports','export_data','manage_billing']),
    Role(id: 2, name: 'Manager', description: 'Team and content management', permissions: ['read','write','manage_users','view_reports','export_data']),
    Role(id: 3, name: 'Editor',  description: 'Content editing access',      permissions: ['read','write','view_reports']),
    Role(id: 4, name: 'Viewer',  description: 'Read-only access',            permissions: ['read']),
  ];
  int _nextId = 5;

  void _open({Role? role}) async {
    final r = await showDialog<Role>(context: context, barrierColor: Colors.black54, builder: (_) => _RoleDialog(role: role));
    if (r != null) {
      setState(() {
        if (role == null) roles.add(Role(id: _nextId++, name: r.name, description: r.description, permissions: r.permissions));
        else { final i = roles.indexWhere((x) => x.id == role.id); if (i != -1) roles[i] = Role(id: role.id, name: r.name, description: r.description, permissions: r.permissions); }
      });
      _toast(context, role == null ? 'Role "${r.name}" created!' : 'Role "${r.name}" updated!');
    }
  }

  @override
  Widget build(BuildContext context) => _scrollView(Column(children: [
    _section(context, title: 'User Roles', child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton.icon(onPressed: () => _open(),
            icon: const Icon(Icons.add, size: 15), label: const Text('Add Role'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      ]),
      const SizedBox(height: 12),
      ...roles.map((r) => _roleCard(context, r)),
    ])),
    _section(context, title: 'Permission Reference', child: Column(
      children: allPermissions.map((p) => Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.chipBg, borderRadius: BorderRadius.circular(8),
          border: const Border(left: BorderSide(color: AppColors.primary, width: 3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary)),
          const SizedBox(height: 3),
          Text(p.description, style: TextStyle(fontSize: 12, color: context.textSecondary)),
        ]),
      )).toList(),
    )),
  ]));

  Widget _roleCard(BuildContext ctx, Role r) => _card(ctx, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(r.name,        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: ctx.textPrimary)),
        Text(r.description, style: TextStyle(color: ctx.textSecondary, fontSize: 12)),
      ]),
      Row(children: [
        _actionBtn('Edit',   const Color(0xFF1976D2), () => _open(role: r)),
        const SizedBox(width: 4),
        _actionBtn('Delete', AppColors.danger, () { setState(() => roles.remove(r)); _toast(ctx, 'Role "${r.name}" deleted.'); }),
      ]),
    ]),
    const SizedBox(height: 12),
    Wrap(spacing: 7, runSpacing: 7, children: allPermissions.map((p) {
      final on = r.permissions.contains(p.id);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: on ? AppColors.primary : ctx.chipBg,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: on ? AppColors.primary : ctx.inputBorder),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(on ? Icons.check_circle : Icons.radio_button_unchecked, size: 13, color: on ? Colors.white : ctx.textSecondary),
          const SizedBox(width: 5),
          Text(p.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: on ? Colors.white : ctx.textSecondary)),
        ]),
      );
    }).toList()),
  ]));
}

class _RoleDialog extends StatefulWidget {
  final Role? role;
  const _RoleDialog({this.role});
  @override
  State<_RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<_RoleDialog> {
  late final TextEditingController _nm, _ds;
  late List<String> _perms;
  @override
  void initState() { super.initState(); _nm = TextEditingController(text: widget.role?.name ?? ''); _ds = TextEditingController(text: widget.role?.description ?? ''); _perms = List.from(widget.role?.permissions ?? []); }
  @override
  void dispose() { _nm.dispose(); _ds.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => _dialogBox(context, width: 480,
    child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _dialogHeader(context, widget.role == null ? 'Add New Role' : 'Edit Role', Icons.security),
      const SizedBox(height: 20),
      _fieldLabel(context, 'Role Name'),
      TextField(controller: _nm, decoration: _inputDec(context, 'e.g., Content Manager'), style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 14),
      _fieldLabel(context, 'Description'),
      TextField(controller: _ds, decoration: _inputDec(context, 'Brief description'), style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 16),
      _fieldLabel(context, 'Permissions'),
      Wrap(spacing: 8, runSpacing: 8, children: allPermissions.map((p) {
        final sel = _perms.contains(p.id);
        return InkWell(
          onTap: () => setState(() { if (sel) _perms.remove(p.id); else _perms.add(p.id); }),
          borderRadius: BorderRadius.circular(7),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: sel ? AppColors.primary : context.chipBg,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: sel ? AppColors.primary : context.inputBorder),
              boxShadow: sel ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2))] : [],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(sel ? Icons.check_circle : Icons.circle_outlined, size: 15, color: sel ? Colors.white : context.textSecondary),
              const SizedBox(width: 6),
              Text(p.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : context.textPrimary)),
            ]),
          ),
        );
      }).toList()),
      const SizedBox(height: 22),
      _dialogActions(context, widget.role == null ? 'Create Role' : 'Save Changes', () {
        if (_nm.text.isEmpty) return;
        Navigator.pop(context, Role(id: 0, name: _nm.text, description: _ds.text, permissions: _perms));
      }),
    ])),
  );
}

// ─────────────────────────────────────────────
//  5. TEAM TAB
// ─────────────────────────────────────────────
class _TeamTab extends StatefulWidget {
  const _TeamTab();
  @override
  State<_TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<_TeamTab> {
  List<TeamMember> members = [
    TeamMember(id: 1, name: 'David Brown',   email: 'david@company.com',   role: 'Manager', status: 'Active',   joinDate: 'Apr 5, 2023'),
    TeamMember(id: 2, name: 'Emma Williams', email: 'emma@company.com',    role: 'Viewer',  status: 'Inactive', joinDate: 'Mar 10, 2023'),
    TeamMember(id: 3, name: 'Lisa Anderson', email: 'lisa@company.com',    role: 'Admin',   status: 'Pending',  joinDate: 'May 12, 2023'),
    TeamMember(id: 4, name: 'Michael Chen',  email: 'michael@company.com', role: 'Editor',  status: 'Active',   joinDate: 'Feb 20, 2023'),
    TeamMember(id: 5, name: 'Sarah Johnson', email: 'sarah@company.com',   role: 'Admin',   status: 'Active',   joinDate: 'Jan 15, 2023'),
  ];
  int _nextId = 6;
  String _sort = 'Name', _filter = 'All';
  bool _asc = true;

  int get _active   => members.where((m) => m.status == 'Active').length;
  int get _pending  => members.where((m) => m.status == 'Pending').length;
  int get _inactive => members.where((m) => m.status == 'Inactive').length;

  List<TeamMember> get _list {
    var l = List.of(members);
    if (_filter == 'Active')   l = l.where((m) => m.status == 'Active').toList();
    if (_filter == 'Inactive') l = l.where((m) => m.status == 'Inactive').toList();
    if (_filter == 'Pending')  l = l.where((m) => m.status == 'Pending').toList();
    l.sort((a, b) {
      final c = _sort == 'Name' ? a.name.compareTo(b.name) : _sort == 'Role' ? a.role.compareTo(b.role) : a.status.compareTo(b.status);
      return _asc ? c : -c;
    });
    return l;
  }

  void _open({TeamMember? member}) async {
    final r = await showDialog<TeamMember>(context: context, barrierColor: Colors.black54, builder: (_) => _MemberDialog(member: member));
    if (r != null) {
      setState(() {
        if (member == null) members.add(TeamMember(id: _nextId++, name: r.name, email: r.email, role: r.role, status: r.status, joinDate: 'Today'));
        else { final i = members.indexWhere((x) => x.id == member.id); if (i != -1) members[i] = TeamMember(id: member.id, name: r.name, email: r.email, role: r.role, status: r.status, joinDate: member.joinDate); }
      });
      _toast(context, member == null ? '${r.name} added!' : '${r.name} updated!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _list;
    return _scrollView(Column(children: [
      Row(children: [
        Expanded(child: _statCard('$_active',          'Active',  context.infoBg,  AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('$_pending',         'Pending', context.warnBg,  const Color(0xFFFF9800))),
        const SizedBox(width: 12),
        Expanded(child: _statCard('$_inactive',        'Inactive',context.dangerBg,AppColors.danger)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('${members.length}', 'Total',   context.blueBg,  const Color(0xFF1976D2))),
      ]),
      const SizedBox(height: 20),
      _section(context, title: 'Team Members', child: Column(children: [
        Row(children: [
          Text('${list.length} members', style: TextStyle(fontSize: 13, color: context.textSecondary)),
          const Spacer(),
          _popupBtn(context, Icons.sort, 'Sort', ['Name','Role','Status'], (v) {
            setState(() { if (_sort == v) _asc = !_asc; else { _sort = v; _asc = true; } });
          }),
          const SizedBox(width: 8),
          _popupBtn(context, Icons.filter_list, 'Filter', ['All','Active','Inactive','Pending'], (v) => setState(() => _filter = v)),
          const SizedBox(width: 10),
          ElevatedButton.icon(onPressed: () => _open(),
              icon: const Icon(Icons.person_add, size: 15), label: const Text('Add Member'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
        ]),
        const SizedBox(height: 14),
        ...list.map((m) => _memberRow(context, m)),
      ])),
    ]));
  }

  Widget _memberRow(BuildContext ctx, TeamMember m) {
    Color sc;
    switch (m.status) {
      case 'Active':  sc = AppColors.success; break;
      case 'Pending': sc = const Color(0xFFFF9800); break;
      default:        sc = AppColors.danger;
    }
    return _card(ctx, child: Row(children: [
      CircleAvatar(radius: 20, backgroundColor: AppColors.primary,
          child: Text(m.name.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(m.name,  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ctx.textPrimary)),
        Text(m.email, style: TextStyle(fontSize: 12, color: ctx.textSecondary)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: sc.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: sc.withOpacity(0.3))),
        child: Text(m.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: sc)),
      ),
      const SizedBox(width: 12),
      SizedBox(width: 68, child: Text(m.role, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ctx.textPrimary))),
      SizedBox(width: 110, child: Text('Joined ${m.joinDate}', style: TextStyle(fontSize: 11, color: ctx.textSecondary))),
      _actionBtn('Edit',   const Color(0xFF1976D2), () => _open(member: m)),
      const SizedBox(width: 4),
      _actionBtn('Remove', AppColors.danger, () { setState(() => members.remove(m)); _toast(ctx, '${m.name} removed.'); }),
    ]));
  }

  Widget _statCard(String val, String label, Color bg, Color accent) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: accent.withOpacity(0.25))),
    child: Column(children: [
      Text(val, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: accent)),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accent.withOpacity(0.8))),
    ]),
  );
}

class _MemberDialog extends StatefulWidget {
  final TeamMember? member;
  const _MemberDialog({this.member});
  @override
  State<_MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<_MemberDialog> {
  late final TextEditingController _nm, _em;
  late String _role, _status;
  @override
  void initState() { super.initState(); _nm = TextEditingController(text: widget.member?.name ?? ''); _em = TextEditingController(text: widget.member?.email ?? ''); _role = widget.member?.role ?? allRoles.first; _status = widget.member?.status ?? allStatuses.first; }
  @override
  void dispose() { _nm.dispose(); _em.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => _dialogBox(context, width: 440,
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _dialogHeader(context, widget.member == null ? 'Add Team Member' : 'Edit Member', Icons.people),
      const SizedBox(height: 20),
      _fieldLabel(context, 'Full Name'),
      TextField(controller: _nm, decoration: _inputDec(context, 'John Doe'), style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 14),
      _fieldLabel(context, 'Email'),
      TextField(controller: _em, decoration: _inputDec(context, 'john@company.com'), style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _fieldLabel(context, 'Role'),
          DropdownButtonFormField<String>(
            value: _role, decoration: _inputDec(context, ''),
            dropdownColor: context.popupBg,
            style: TextStyle(fontSize: 13, color: context.textPrimary),
            onChanged: (v) => setState(() => _role = v!),
            items: allRoles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
          ),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _fieldLabel(context, 'Status'),
          DropdownButtonFormField<String>(
            value: _status, decoration: _inputDec(context, ''),
            dropdownColor: context.popupBg,
            style: TextStyle(fontSize: 13, color: context.textPrimary),
            onChanged: (v) => setState(() => _status = v!),
            items: allStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          ),
        ])),
      ]),
      const SizedBox(height: 22),
      _dialogActions(context, widget.member == null ? 'Add Member' : 'Save Changes', () {
        if (_nm.text.isEmpty || _em.text.isEmpty) return;
        Navigator.pop(context, TeamMember(id: 0, name: _nm.text, email: _em.text, role: _role, status: _status, joinDate: ''));
      }),
    ]),
  );
}

// ─────────────────────────────────────────────
//  6. TAX TAB
// ─────────────────────────────────────────────
class _TaxTab extends StatefulWidget {
  const _TaxTab();
  @override
  State<_TaxTab> createState() => _TaxTabState();
}

class _TaxTabState extends State<_TaxTab> {
  List<Tax> taxes = [
    Tax(id: 1, region: 'California', type: 'State Tax',       rate: 7.25),
    Tax(id: 2, region: 'New York',   type: 'State Tax',       rate: 8.875),
    Tax(id: 3, region: 'Texas',      type: 'State Tax',       rate: 6.25),
    Tax(id: 4, region: 'VAT (EU)',   type: 'Value Added Tax', rate: 20),
  ];
  int _nextId = 5;
  bool _incTax = false, _auto = true, _showBreak = true, _exempt = false;

  void _open({Tax? t}) async {
    final r = await showDialog<Tax>(context: context, builder: (_) => _TaxDialog(tax: t));
    if (r != null) {
      setState(() {
        if (t == null) taxes.add(Tax(id: _nextId++, region: r.region, type: r.type, rate: r.rate));
        else { final i = taxes.indexWhere((x) => x.id == t.id); if (i != -1) taxes[i] = r; }
      });
      _toast(context, t == null ? 'Tax rate added!' : 'Tax rate updated!');
    }
  }

  @override
  Widget build(BuildContext context) {
    const sub = 100.0;
    final tx  = taxes.isNotEmpty ? sub * taxes.first.rate / 100 : 0.0;
    return _scrollView(Column(children: [
      _section(context, title: 'Tax Rates', child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton.icon(onPressed: () => _open(),
              icon: const Icon(Icons.add, size: 15), label: const Text('Add Tax Rate'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
        ]),
        const SizedBox(height: 12),
        ...taxes.map((t) => _taxCard(context, t)),
      ])),
      _section(context, title: 'Tax Settings', child: Column(children: [
        _toggleCard(context, 'Prices Include Tax',  'Display prices with tax',     _incTax,   (v) { setState(() => _incTax = v);    _toast(context, v ? 'Prices include tax' : 'Prices exclude tax'); }, icon: Icons.price_change),
        _toggleCard(context, 'Auto-Calculate Tax',  'Auto-calc by location',       _auto,     (v) { setState(() => _auto = v);      _toast(context, 'Auto-calc ${v?"on":"off"}'); }, icon: Icons.calculate),
        _toggleCard(context, 'Show Tax Breakdown',  'Show tax detail at checkout', _showBreak,(v) { setState(() => _showBreak = v); _toast(context, 'Breakdown ${v?"shown":"hidden"}'); }, icon: Icons.receipt_long),
        _toggleCard(context, 'Tax Exempt Orders',   'Allow tax-exempt accounts',   _exempt,   (v) { setState(() => _exempt = v);    _toast(context, 'Exempt ${v?"on":"off"}'); }, icon: Icons.discount),
      ])),
      _section(context, title: 'Calculation Preview', child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: context.previewBg, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(children: [
          _pr(context, 'Subtotal:', '\$${sub.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _pr(context, 'Tax (${taxes.isNotEmpty ? taxes.first.rate : 0}%):', '\$${tx.toStringAsFixed(2)}', accent: true),
          Divider(color: AppColors.primary.withOpacity(0.3), height: 24),
          _pr(context, 'Total:', '\$${(sub + tx).toStringAsFixed(2)}', bold: true),
        ]),
      )),
    ]));
  }

  Widget _pr(BuildContext ctx, String l, String v, {bool accent = false, bool bold = false}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: ctx.textPrimary)),
        Text(v, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.bold : FontWeight.w600, color: accent ? AppColors.primary : ctx.textPrimary)),
      ]);

  Widget _taxCard(BuildContext ctx, Tax t) => _card(ctx, child: Row(children: [
    Container(width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.attach_money, color: AppColors.primary, size: 20)),
    const SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t.region, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ctx.textPrimary)),
      Text(t.type,   style: TextStyle(fontSize: 12, color: ctx.textSecondary)),
    ])),
    _chip('${t.rate}%', 'Rate', AppColors.primary),
    const SizedBox(width: 10),
    _actionBtn('Edit',   const Color(0xFF1976D2), () => _open(t: t)),
    const SizedBox(width: 4),
    _actionBtn('Delete', AppColors.danger, () { setState(() => taxes.removeWhere((x) => x.id == t.id)); _toast(ctx, 'Tax deleted.'); }),
  ]));
}

class _TaxDialog extends StatefulWidget {
  final Tax? tax;
  const _TaxDialog({this.tax});
  @override
  State<_TaxDialog> createState() => _TaxDialogState();
}

class _TaxDialogState extends State<_TaxDialog> {
  late final TextEditingController _reg, _rate;
  String _type = 'State Tax';
  final List<String> _types = ['State Tax','Value Added Tax','Sales Tax','GST'];
  @override
  void initState() { super.initState(); _reg = TextEditingController(text: widget.tax?.region ?? ''); _rate = TextEditingController(text: widget.tax?.rate.toString() ?? ''); _type = widget.tax?.type ?? 'State Tax'; }
  @override
  void dispose() { _reg.dispose(); _rate.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => _dialogBox(context, width: 420,
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _dialogHeader(context, widget.tax == null ? 'Add Tax Rate' : 'Edit Tax Rate', Icons.attach_money),
      const SizedBox(height: 20),
      _fieldLabel(context, 'Region'),
      TextField(controller: _reg, decoration: _inputDec(context, 'e.g., Florida'), style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 14),
      _fieldLabel(context, 'Tax Type'),
      DropdownButtonFormField<String>(
        value: _type, decoration: _inputDec(context, ''),
        dropdownColor: context.popupBg,
        style: TextStyle(fontSize: 13, color: context.textPrimary),
        items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
        onChanged: (v) { if (v != null) setState(() => _type = v); },
      ),
      const SizedBox(height: 14),
      _fieldLabel(context, 'Tax Rate (%)'),
      TextField(controller: _rate, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _inputDec(context, 'e.g., 7.25'), style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 22),
      _dialogActions(context, widget.tax == null ? 'Add Tax Rate' : 'Save Changes', () {
        if (_reg.text.isEmpty || _rate.text.isEmpty) return;
        final r = double.tryParse(_rate.text); if (r == null) return;
        Navigator.pop(context, Tax(id: widget.tax?.id ?? 0, region: _reg.text, type: _type, rate: r));
      }),
    ]),
  );
}

// ─────────────────────────────────────────────
//  7. SECURITY TAB
// ─────────────────────────────────────────────
class _SecurityTab extends StatefulWidget {
  const _SecurityTab();
  @override
  State<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<_SecurityTab> {
  final _cur = TextEditingController(), _new = TextEditingController(), _con = TextEditingController();
  bool _curV = false, _newV = false, _conV = false;
  bool _authApp = true, _sms = false;
  String _strength = ''; Color _sc = Colors.grey;

  List<Session> sessions = [
    Session(device: 'Chrome on Windows', location: 'New York, USA',      ip: '192.168.1.1', time: '2 hours ago', isCurrentSession: true),
    Session(device: 'Safari on iPhone',  location: 'New York, USA',      ip: '192.168.1.2', time: '2 hours ago'),
    Session(device: 'Firefox on MacOS',  location: 'San Francisco, USA', ip: '192.168.1.3', time: '1 day ago'),
  ];
  List<LoginHistory> history = [
    LoginHistory(device: 'Chrome on Windows', location: 'New York, USA',      time: '2 hours ago', isSuccessful: true),
    LoginHistory(device: 'Safari on iPhone',  location: 'New York, USA',      time: '1 day ago',   isSuccessful: true),
    LoginHistory(device: 'Unknown device',    location: 'London, UK',         time: '3 days ago',  isSuccessful: false),
    LoginHistory(device: 'Firefox on MacOS',  location: 'San Francisco, USA', time: '2 days ago',  isSuccessful: true),
  ];

  void _chk(String p) {
    if (p.isEmpty) { setState(() { _strength = ''; _sc = Colors.grey; }); return; }
    int s = 0;
    if (p.length >= 8)  s++; if (p.length >= 12) s++;
    if (RegExp(r'[a-z]').hasMatch(p)) s++; if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++; if (RegExp(r'[!@#\$%^&*]').hasMatch(p)) s++;
    setState(() { if (s <= 2) { _strength = 'Weak'; _sc = Colors.red; } else if (s <= 4) { _strength = 'Medium'; _sc = Colors.orange; } else { _strength = 'Strong'; _sc = Colors.green; } });
  }

  InputDecoration _pd(BuildContext ctx, String hint, bool vis, VoidCallback t) =>
      _inputDec(ctx, hint).copyWith(
        suffixIcon: IconButton(icon: Icon(vis ? Icons.visibility : Icons.visibility_off, size: 18, color: ctx.textSecondary), onPressed: t),
      );

  @override
  Widget build(BuildContext context) => _scrollView(Column(children: [
    _section(context, title: 'Change Password', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fieldLabel(context, 'Current Password'),
      TextField(controller: _cur, obscureText: !_curV,
          decoration: _pd(context, 'Enter current password', _curV, () => setState(() => _curV = !_curV)),
          style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 14),
      _fieldLabel(context, 'New Password'),
      TextField(controller: _new, obscureText: !_newV, onChanged: _chk,
          decoration: _pd(context, 'Enter new password', _newV, () => setState(() => _newV = !_newV)),
          style: TextStyle(fontSize: 13, color: context.textPrimary)),
      if (_strength.isNotEmpty) ...[
        const SizedBox(height: 8),
        Row(children: [
          Text('Strength: ', style: TextStyle(fontSize: 12, color: context.textSecondary)),
          Text(_strength, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _sc)),
          const SizedBox(width: 10),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _strength == 'Weak' ? 0.33 : _strength == 'Medium' ? 0.66 : 1.0,
              backgroundColor: context.inputBorder, color: _sc, minHeight: 5,
            ),
          )),
        ]),
      ],
      const SizedBox(height: 14),
      _fieldLabel(context, 'Confirm New Password'),
      TextField(controller: _con, obscureText: !_conV,
          decoration: _pd(context, 'Confirm new password', _conV, () => setState(() => _conV = !_conV)),
          style: TextStyle(fontSize: 13, color: context.textPrimary)),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: context.blueInfoBg, borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1976D2).withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.info, color: Color(0xFF1976D2), size: 16), SizedBox(width: 6),
            Text('Password Requirements', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2), fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          ...['Min 8 characters','Uppercase & lowercase','At least one number','Special character'].map((r) =>
              Padding(padding: const EdgeInsets.only(bottom: 3), child: Row(children: [
                const Icon(Icons.check_circle, size: 13, color: Color(0xFF1976D2)), const SizedBox(width: 6),
                Text(r, style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2))),
              ]))),
        ]),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          if (_cur.text.isEmpty || _new.text.isEmpty || _con.text.isEmpty) { _toast(context, 'Fill all fields', error: true); return; }
          if (_new.text != _con.text) { _toast(context, 'Passwords do not match', error: true); return; }
          _cur.clear(); _new.clear(); _con.clear(); setState(() => _strength = '');
          _toast(context, 'Password updated!');
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text('Update Password', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    ])),

    _section(context, title: 'Two-Factor Authentication', child: Column(children: [
      _card(context, bg: context.infoBg, child: Row(children: [
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.verified_user, color: AppColors.success, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('2FA is Enabled', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary)),
          Text('Your account is protected', style: TextStyle(fontSize: 12, color: context.textSecondary)),
        ])),
        const Icon(Icons.check_circle, color: AppColors.success, size: 24),
      ])),
      _toggleCard(context, 'Authenticator App', 'Use app to generate codes', _authApp, (v) { setState(() => _authApp = v); _toast(context, 'Authenticator ${v?"on":"off"}'); }, icon: Icons.phone_android),
      _toggleCard(context, 'SMS Authentication', 'Receive codes via text',   _sms,     (v) { setState(() => _sms = v);     _toast(context, 'SMS auth ${v?"on":"off"}'); }, icon: Icons.sms),
    ])),

    _section(context, title: 'Active Sessions', child: Column(children: [
      ...sessions.map((s) => _card(context,
        bg: s.isCurrentSession ? context.infoBg : null,
        child: Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(
                  color: s.isCurrentSession ? AppColors.success.withOpacity(0.15) : context.chipBg,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(s.isCurrentSession ? Icons.computer : Icons.devices,
                  color: s.isCurrentSession ? AppColors.success : context.textSecondary, size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(s.device, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary)),
              if (s.isCurrentSession) ...[
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(10)),
                    child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
              ],
            ]),
            Text('${s.location} • ${s.time} • IP: ${s.ip}', style: TextStyle(fontSize: 11, color: context.textSecondary)),
          ])),
          if (!s.isCurrentSession)
            _actionBtn('Revoke', AppColors.danger, () { setState(() => sessions.remove(s)); _toast(context, 'Session revoked.'); }),
        ]),
      )),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () { setState(() => sessions.removeWhere((s) => !s.isCurrentSession)); _toast(context, 'All sessions revoked.'); },
        icon: const Icon(Icons.logout, size: 16),
        label: const Text('Revoke All Other Sessions'),
        style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    ])),

    _section(context, title: 'Login History', child: Column(
        children: history.map((h) => _card(context, child: Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(
                  color: (h.isSuccessful ? AppColors.success : AppColors.danger).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(h.isSuccessful ? Icons.check_circle : Icons.cancel,
                  color: h.isSuccessful ? AppColors.success : AppColors.danger, size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(h.isSuccessful ? 'Successful Login' : 'Failed Attempt',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                    color: h.isSuccessful ? context.textPrimary : AppColors.danger)),
            Text('${h.device} • ${h.location}', style: TextStyle(fontSize: 12, color: context.textSecondary)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: context.chipBg, borderRadius: BorderRadius.circular(6)),
            child: Text(h.time, style: TextStyle(fontSize: 11, color: context.textSecondary, fontWeight: FontWeight.w600)),
          ),
        ]))).toList())),

    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.dangerBg, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.warning_amber, color: AppColors.danger, size: 20), SizedBox(width: 8),
          Text('Danger Zone', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.danger)),
        ]),
        const SizedBox(height: 6),
        Text('These actions are irreversible. Please proceed with caution.', style: TextStyle(fontSize: 12, color: context.textSecondary)),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          ElevatedButton(onPressed: () => _toast(context, 'Account deactivated.'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700], foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Deactivate Account')),
          ElevatedButton(onPressed: () => _toast(context, 'Account deletion initiated.'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Delete Account')),
          OutlinedButton.icon(
              onPressed: () => _toast(context, 'Data export started. Check your email.'),
              icon: const Icon(Icons.download, size: 15),
              label: const Text('Export My Data'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.textPrimary,
                side: BorderSide(color: context.inputBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              )),
        ]),
      ]),
    ),
  ]));
}