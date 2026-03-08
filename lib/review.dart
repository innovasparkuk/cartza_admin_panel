
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Review {
  String id, userName, text;
  double rating;
  String? adminReply, productId, productName;
  bool isApproved;
  DateTime date;
  Review({
    required this.id,
    required this.userName,
    required this.text,
    required this.rating,
    this.adminReply,
    this.isApproved = false,
    required this.date,
    this.productId,
    this.productName,
  });
}

class ReviewsPage extends StatefulWidget {
  final String? productId, productName;
  const ReviewsPage({super.key, this.productId, this.productName});
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with TickerProviderStateMixin {
  final _replyCtrl = TextEditingController();
  String _filter = 'All';
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const _coral = Color(0xFFF64242);
  static const _mint = Color(0xDA499F4D);
  static const _amber = Color(0xFFFFB703);
  static const _crimson = Color(0xFFEF4444);

  final List<Review> _all = [
    Review(
      id: '1',
      userName: 'Alex Johnson',
      productId: 'p1',
      productName: 'Wireless Headphones',
      text:
          'Great product! The sound quality is amazing and battery lasts all day.',
      rating: 5,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      id: '2',
      userName: 'Maria Garcia',
      productId: 'p2',
      productName: 'Running Shoes',
      text: 'Crashes occasionally when I try to login. Please fix this issue.',
      rating: 2,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Review(
      id: '3',
      userName: 'David Smith',
      productId: 'p1',
      productName: 'Wireless Headphones',
      text: 'Works fine for basic use. Could use some more advanced features.',
      rating: 3,
      isApproved: true,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Review(
      id: '4',
      userName: 'Sarah Williams',
      productId: 'p3',
      productName: 'Smart Watch',
      text: 'Excellent experience overall! Customer support was very helpful.',
      rating: 4,
      isApproved: true,
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Review(
      id: '5',
      userName: 'James Wilson',
      productId: 'p2',
      productName: 'Running Shoes',
      text: 'Loading times could be better, but overall a solid product.',
      rating: 3,
      date: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _replyCtrl.dispose();
    super.dispose();
  }

  List<Review> get _base => widget.productId != null
      ? _all.where((r) => r.productId == widget.productId).toList()
      : _all;
  List<Review> get _reviews {
    if (_filter == 'Approved') return _base.where((r) => r.isApproved).toList();
    if (_filter == 'Pending') return _base.where((r) => !r.isApproved).toList();
    return _base;
  }

  double get _avg => _base.isEmpty
      ? 0
      : _base.fold(0.0, (s, r) => s + r.rating) / _base.length;
  List<int> get _dist {
    final d = List.filled(5, 0);
    for (final r in _base) {
      d[r.rating.clamp(1, 5).toInt() - 1]++;
    }
    return d;
  }

  String _fmt(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _avatar(String n) => [
    const Color(0xFF6366F1),
    const Color(0xFF8B5CF6),
    const Color(0xFFEC4899),
    const Color(0xFF06B6D4),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
  ][n.codeUnitAt(0) % 6];

  // ── Theme helpers — auto light/dark ──────────────────────────
  bool get _dark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _dark ? const Color(0xFF0D0D1A) : const Color(0xFFF0F2F8);
  Color get _card => _dark ? const Color(0xFF13132B) : Colors.white;
  Color get _surf => _dark ? const Color(0xFF1A1A35) : const Color(0xFFF5F6FA);
  Color get _bord => _dark ? const Color(0xFF252548) : const Color(0xFFE2E4F0);
  Color get _tP => _dark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A2E);
  Color get _tS => _dark ? Colors.white54 : const Color(0xFF7C7F9A);
  Color get _div =>
      _dark ? Colors.white.withOpacity(0.05) : const Color(0xFFEEEFF5);
  Color get _foot =>
      _dark ? Colors.white.withOpacity(0.02) : const Color(0xFFF8F9FC);
  Color get _idle =>
      _dark ? Colors.white.withOpacity(0.04) : const Color(0xFFF0F2F8);
  Color get _progBg =>
      _dark ? Colors.white.withOpacity(0.07) : const Color(0xFFE8EAF2);
  Color get _handle => _dark ? Colors.white24 : const Color(0xFFDDDFF0);

  // ── Hand cursor wrapper ───────────────────────────────────────
  Widget _tap({required VoidCallback onTap, required Widget child}) =>
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: child),
      );

  // ── Delete dialog ─────────────────────────────────────────────
  void _delete(Review r) {
    HapticFeedback.mediumImpact();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (_, a, __, c) => ScaleTransition(
        scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
        child: c,
      ),
      pageBuilder: (ctx, _, __) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 500,
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _dark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _crimson.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  color: _crimson.withOpacity(_dark ? 0.2 : 0.12),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _crimson.withOpacity(0.12),
                    border: Border.all(color: _crimson.withOpacity(0.35)),
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: _crimson,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Delete Review',
                  style: TextStyle(
                    color: _tP,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(color: _tS, fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _tap(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _dark
                                ? Colors.white.withOpacity(0.08)
                                : const Color(0xFFF0F2F8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _bord),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: _tS,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _tap(
                        onTap: () {
                          setState(() => _all.removeWhere((x) => x.id == r.id));
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _crimson,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _approve(Review r) {
    HapticFeedback.selectionClick();
    setState(() => r.isApproved = !r.isApproved);
  }

  void _reply(Review r) {
    _replyCtrl.text = r.adminReply ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
        ),
        decoration: BoxDecoration(
          color: _dark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _coral.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_dark ? 0.5 : 0.12),
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _handle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _avatar(r.userName),
                    boxShadow: [
                      BoxShadow(
                        color: _avatar(r.userName).withOpacity(0.35),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      r.userName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reply to ${r.userName}',
                        style: TextStyle(
                          color: _tP,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Visible to all customers',
                        style: TextStyle(color: _tS, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Close — hand cursor
                _tap(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _dark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFF0F2F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _bord),
                    ),
                    child: Icon(Icons.close_rounded, color: _tS, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _replyCtrl,
              maxLines: 4,
              style: TextStyle(color: _tP, fontSize: 14, height: 1.6),
              decoration: InputDecoration(
                hintText: 'Write your reply here...',
                hintStyle: TextStyle(color: _tS),
                filled: true,
                fillColor: _dark
                    ? Colors.white.withOpacity(0.05)
                    : const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: _bord),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: _bord),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: _coral, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Cancel — hand cursor
                Expanded(
                  child: _tap(
                    onTap: () {
                      Navigator.pop(ctx);
                      _replyCtrl.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: _dark
                            ? Colors.white.withOpacity(0.07)
                            : const Color(0xFFF0F2F8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _bord),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: _tS,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Send Reply — hand cursor
                Expanded(
                  child: _tap(
                    onTap: () {
                      setState(() {
                        r.adminReply = _replyCtrl.text.trim().isEmpty
                            ? null
                            : _replyCtrl.text.trim();
                      });
                      _replyCtrl.clear();
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_mint, Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _mint.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Send Reply',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 16,
                20,
                20,
              ),
              decoration: BoxDecoration(
                color: _card,
                border: Border(bottom: BorderSide(color: _bord)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_dark ? 0.3 : 0.06),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Back — hand cursor
                      _tap(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _coral.withOpacity(0.22),
                                _coral.withOpacity(0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _coral.withOpacity(0.35)),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: _coral,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productId != null
                                  ? widget.productName ?? 'Reviews'
                                  : 'Customer Reviews',
                              style: TextStyle(
                                color: _tP,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_base.length} reviews  ·  ${_base.where((r) => r.isApproved).length} approved',
                              style: TextStyle(color: _tS, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _mint.withOpacity(_dark ? 0.1 : 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _mint.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: _mint,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${_base.where((r) => r.isApproved).length} Live',
                              style: const TextStyle(
                                color: _mint,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_base.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _ratingCard(),
                    const SizedBox(height: 16),
                  ],
                  // Filter chips — hand cursor
                  Row(
                    children: ['All', 'Approved', 'Pending'].map((f) {
                      final on = _filter == f;
                      final c = f == 'Approved'
                          ? _mint
                          : f == 'Pending'
                          ? _amber
                          : _coral;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _tap(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _filter = f);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: on ? c.withOpacity(0.15) : _surf,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: on ? c.withOpacity(0.55) : _bord,
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                color: on ? c : _tS,
                                fontSize: 12.5,
                                fontWeight: on
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // ── List ─────────────────────────────────────────────────
            Expanded(
              child: _reviews.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: _surf,
                              shape: BoxShape.circle,
                              border: Border.all(color: _bord),
                            ),
                            child: Icon(
                              Icons.rate_review_outlined,
                              size: 32,
                              color: _tS.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No reviews found',
                            style: TextStyle(
                              color: _tS,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reviews will appear here',
                            style: TextStyle(
                              color: _tS.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      itemCount: _reviews.length,
                      itemBuilder: (_, i) => TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 300 + i * 60),
                        curve: Curves.easeOut,
                        builder: (_, v, child) => Opacity(
                          opacity: v,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - v)),
                            child: child,
                          ),
                        ),
                        child: _reviewCard(_reviews[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: _surf,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _coral.withOpacity(0.2)),
      gradient: LinearGradient(
        colors: [_coral.withOpacity(0.06), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_coral, Color(0xFFFF8F6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _coral.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _avg.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                  letterSpacing: -1,
                ),
              ),
              Text(
                '/ 5',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      i < _avg.floor()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 14,
                      color: _amber,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_base.length} reviews',
                    style: TextStyle(
                      color: _tS,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (var i = 4; i >= 0; i--)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          color: _tP,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.star_rounded, size: 11, color: _amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0,
                              end: _base.isEmpty ? 0 : _dist[i] / _base.length,
                            ),
                            duration: Duration(milliseconds: 600 + i * 80),
                            curve: Curves.easeOut,
                            builder: (_, v, __) => LinearProgressIndicator(
                              value: v,
                              minHeight: 6,
                              backgroundColor: _progBg,
                              valueColor: AlwaysStoppedAnimation(
                                i >= 3
                                    ? _mint
                                    : i == 2
                                    ? _amber
                                    : _crimson,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 16,
                        child: Text(
                          '${_dist[i]}',
                          style: TextStyle(
                            fontSize: 11,
                            color: _tS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _reviewCard(Review r) {
    final rc = r.rating >= 4
        ? _mint
        : r.rating >= 3
        ? _amber
        : _crimson;
    final av = _avatar(r.userName);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: r.isApproved ? _mint.withOpacity(0.25) : _bord,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_dark ? 0 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: av,
                        boxShadow: [
                          BoxShadow(color: av.withOpacity(0.35), blurRadius: 8),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          r.userName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  r.userName,
                                  style: TextStyle(
                                    color: _tP,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              if (r.isApproved) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _mint.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _mint.withOpacity(0.3),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 9,
                                        color: _mint,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'Live',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: _mint,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 10,
                                color: _tS.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _fmt(r.date),
                                style: TextStyle(fontSize: 11, color: _tS),
                              ),
                              if (r.productName != null &&
                                  widget.productId == null) ...[
                                Text(
                                  '  ·  ',
                                  style: TextStyle(color: _tS, fontSize: 11),
                                ),
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 10,
                                  color: _tS.withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    r.productName!,
                                    style: TextStyle(fontSize: 11, color: _tS),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: rc.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: rc.withOpacity(0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 13, color: rc),
                          const SizedBox(width: 4),
                          Text(
                            r.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: rc,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(
                        i < r.rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 14,
                        color: rc,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  r.text,
                  style: TextStyle(
                    color: _dark
                        ? Colors.white.withOpacity(0.75)
                        : _tP.withOpacity(0.8),
                    fontSize: 13.5,
                    height: 1.65,
                    letterSpacing: 0.1,
                  ),
                ),
                if (r.adminReply != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _mint.withOpacity(_dark ? 0.05 : 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _mint.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _mint.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                size: 10,
                                color: _mint,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: _mint,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r.adminReply!,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.55,
                            color: _dark
                                ? Colors.white.withOpacity(0.7)
                                : _tP.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Footer buttons
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              color: _foot,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border(top: BorderSide(color: _div)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _btn(
                  label: r.isApproved ? 'Approved' : 'Approve',
                  icon: r.isApproved
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: _mint,
                  active: r.isApproved,
                  onTap: () => _approve(r),
                ),
                const SizedBox(width: 8),
                _btn(
                  label: r.adminReply == null ? 'Reply' : 'Edit Reply',
                  icon: Icons.reply_rounded,
                  color: _coral,
                  active: true,
                  solid: true,
                  onTap: () => _reply(r),
                ),
                const SizedBox(width: 8),
                _btn(
                  label: 'Delete',
                  icon: Icons.delete_outline_rounded,
                  color: _crimson,
                  active: false,
                  onTap: () => _delete(r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Action button — hand cursor + light/dark aware ────────────
  Widget _btn({
    required String label,
    required IconData icon,
    required Color color,
    required bool active,
    bool solid = false,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 👆 hand cursor
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            gradient: solid
                ? LinearGradient(colors: [color, color.withOpacity(0.8)])
                : null,
            color: solid
                ? null
                : active
                ? color.withOpacity(_dark ? 0.12 : 0.1)
                : _idle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: solid
                  ? Colors.transparent
                  : active
                  ? color.withOpacity(0.4)
                  : _bord,
              width: 0.8,
            ),
            boxShadow: solid
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: solid
                    ? Colors.white
                    : active
                    ? color
                    : color.withOpacity(0.75),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  color: solid
                      ? Colors.white
                      : active
                      ? color
                      : color.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
