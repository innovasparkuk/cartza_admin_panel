import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'transaction.dart';
class AddOrderPage2 extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String billAmount;
  final LatLng orderLocation;

  const AddOrderPage2({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.billAmount,
    required this.orderLocation,
  });

  @override
  State<AddOrderPage2> createState() => _AddOrderPage2State();
}

/// Lightweight theme helper — reads brightness from context once,
/// then every widget just calls t.card, t.textPrimary, etc.
class _T {
  final bool dark;
  const _T(this.dark);

  // Accent colors (same in both modes)
  static const orange     = Color(0xFFFF6B35);
  static const orangeDeep = Color(0xFFE8520A);
  static const green      = Color(0xFF22C55E);
  static const red        = Color(0xFFEF4444);
  static const blue       = Color(0xFF3B82F6);

  // Adaptive
  Color get bg    => dark ? const Color(0xFF0D0D0D) : const Color(0xFFF4F4F6);
  Color get card  => dark ? const Color(0xFF161616) : Colors.white;
  Color get surf  => dark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F3);
  Color get bord  => dark ? const Color(0xFF2A2A2A) : const Color(0xFFE2E2E8);
  Color get tp    => dark ? const Color(0xFFF5F5F5) : const Color(0xFF111111);
  Color get ts    => dark ? const Color(0xFF888888) : const Color(0xFF777777);
  Color get sh    => dark ? Colors.black54        : Colors.black12;
  Color get eta1  => dark ? const Color(0xFF1A1208) : const Color(0xFFFFF8F3);
  Color get eta2  => dark ? const Color(0xFF1E1410) : const Color(0xFFFFF1E6);
  Color get abBg  => dark ? const Color(0xFF161616) : Colors.white;
  String get tile => dark
      ? "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png"
      : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
}

class _AddOrderPage2State extends State<AddOrderPage2>
    with TickerProviderStateMixin {
  final LatLng _rider = const LatLng(24.8700, 67.0100);
  final Distance _d   = const Distance();

  late AnimationController _pulse, _slide;
  late Animation<double>   _pulseA;
  late Animation<Offset>   _slideA;

  double get _km  => _d.as(LengthUnit.Kilometer, _rider, widget.orderLocation);
  int    get _eta => (_km / 30 * 60).round() + 5;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseA = Tween<double>(begin: 0.85, end: 1.15)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    _slide = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _slideA = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slide, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pulse.dispose();
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _T(Theme.of(context).brightness == Brightness.dark);
    return Scaffold(
      backgroundColor: t.bg,
      body: CustomScrollView(slivers: [
        _appBar(t),
        SliverToBoxAdapter(
          child: SlideTransition(
            position: _slideA,
            child: FadeTransition(
              opacity: _slide,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _heroCard(t),
                  const SizedBox(height: 16),
                  _statsRow(t),
                  const SizedBox(height: 16),
                  _mapCard(t),
                  const SizedBox(height: 16),
                  _customerCard(t),
                  const SizedBox(height: 16),
                  _timeline(t),
                  const SizedBox(height: 16),
                  _actions(t),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────
  // ── AppBar ──────────────────────────────────────────────────
  SliverAppBar _appBar(_T t) => SliverAppBar(
    expandedHeight: 108,
    pinned: true,
    backgroundColor: t.abBg,
    surfaceTintColor: Colors.transparent,
    elevation: t.dark ? 0 : 1,
    shadowColor: t.sh,
    leading: IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: t.surf, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: t.bord),
        ),
        child: Icon(Icons.arrow_back_ios_new, color: t.tp, size: 16),
      ),
      onPressed: () => Navigator.pop(context),
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 12, top: 6, bottom: 6), // Reduced margin
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
        decoration: BoxDecoration(
          color: _T.green.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16), // Slightly smaller radius
          border: Border.all(color: _T.green.withOpacity(0.4)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [ // Added mainAxisSize.min
          AnimatedBuilder(
            animation: _pulseA,
            builder: (_, __) => Transform.scale(
              scale: _pulseA.value,
              child: Container(
                width: 6, // Smaller dot
                height: 6, // Smaller dot
                decoration: const BoxDecoration(color: _T.green, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 4), // Reduced spacing
          const Text(
            "Active", // Shortened text from "Rider Active" to just "Active"
            style: TextStyle(
              color: _T.green,
              fontSize: 11, // Slightly smaller font
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ]),
      ),
    ],
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
          color: t.abBg,
          border: Border(bottom: BorderSide(color: t.bord)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 56, 72, 0),
        alignment: Alignment.centerLeft,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [ // Changed to center
          Container(
            padding: const EdgeInsets.all(8), // Slightly smaller padding
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [_T.orange, _T.orangeDeep]),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 20), // Smaller icon
          ),
          const SizedBox(width: 8), // Slightly increased spacing
          Expanded(
            child: Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                  Text(
                    _truncateOrderId(widget.orderId),
                    style: const TextStyle(
                      color: _T.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      height: 1.2, // Tighter line height
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Reduced spacing
                  Text(
                    "Live Tracking",
                    style: TextStyle(
                      color: t.tp,
                      fontSize: 15, // Slightly smaller
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      height: 1.2, // Tighter line height
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    ),
  );

// Update the truncate method to handle shorter display
  String _truncateOrderId(String orderId) {
    const maxLength = 10; // Reduced from 15 to 10 for more compact display
    if (orderId.length <= maxLength) return "ORDER #$orderId";
    return "ORDER #${orderId.substring(0, maxLength)}...";
  }

  // ── ETA Hero ────────────────────────────────────────────────
  Widget _heroCard(_T t) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [t.eta1, t.eta2],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _T.orange.withOpacity(0.3)),
      boxShadow: [BoxShadow(
        color: _T.orange.withOpacity(t.dark ? 0.12 : 0.08),
        blurRadius: 30, offset: const Offset(0, 8),
      )],
    ),
    child: Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("ESTIMATED ARRIVAL",
              style: TextStyle(color: _T.orange, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 1.8)),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("$_eta", style: TextStyle(color: t.tp, fontSize: 52,
                fontWeight: FontWeight.w900, height: 1, letterSpacing: -2)),
            Padding(padding: const EdgeInsets.only(bottom: 8, left: 6),
                child: Text("min", style: TextStyle(color: t.ts, fontSize: 18, fontWeight: FontWeight.w500))),
          ]),
          const SizedBox(height: 6),
          Text("${_km.toStringAsFixed(1)} km away from destination",
              style: TextStyle(color: t.ts, fontSize: 13)),
        ]),
      ),
      AnimatedBuilder(
        animation: _pulseA,
        builder: (_, __) => Transform.scale(
          scale: _pulseA.value * 0.15 + 0.85,
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_T.orange, _T.orangeDeep],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: _T.orange.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
            ),
            child: const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 36),
          ),
        ),
      ),
    ]),
  );

  // ── Stats ───────────────────────────────────────────────────
  Widget _statsRow(_T t) => Row(children: [
    Expanded(child: _statTile(t, "Distance", "${_km.toStringAsFixed(1)} km", Icons.straighten_rounded, _T.blue)),
    const SizedBox(width: 12),
    Expanded(child: _statTile(t, "Speed", "30 km/h", Icons.speed_rounded, _T.orange)),
    const SizedBox(width: 12),
    Expanded(child: _statTile(t, "Status", "On Route", Icons.radio_button_checked, _T.green)),
  ]);

  Widget _statTile(_T t, String label, String value, IconData icon, Color c) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: t.card, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: t.bord),
      boxShadow: [BoxShadow(color: t.sh, blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: c, size: 20),
      const SizedBox(height: 10),
      Text(value, style: TextStyle(color: t.tp, fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(color: t.ts, fontSize: 11)),
    ]),
  );

  // ── Map ─────────────────────────────────────────────────────
  Widget _mapCard(_T t) => Container(
    decoration: BoxDecoration(
      color: t.card, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: t.bord),
      boxShadow: [BoxShadow(color: t.sh, blurRadius: 20, offset: const Offset(0, 6))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Icon(Icons.map_rounded, color: _T.orange, size: 18),
            const SizedBox(width: 8),
            Text("Delivery Route", style: TextStyle(color: t.tp, fontSize: 15,
                fontWeight: FontWeight.w700, letterSpacing: -0.3)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _T.green.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _T.green.withOpacity(0.3)),
            ),
            child: const Text("LIVE", style: TextStyle(color: _T.green, fontSize: 10,
                fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          ),
        ]),
      ),
      ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: SizedBox(height: 300, child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              (widget.orderLocation.latitude + _rider.latitude) / 2,
              (widget.orderLocation.longitude + _rider.longitude) / 2,
            ),
            initialZoom: 12,
          ),
          children: [
            TileLayer(urlTemplate: t.tile, userAgentPackageName: "com.example.app",
                tileDisplay: const TileDisplay.fadeIn()),
            PolylineLayer(polylines: [
              Polyline(points: [_rider, widget.orderLocation],
                  color: _T.orange, strokeWidth: 4, borderStrokeWidth: 2, borderColor: Colors.black26),
            ]),
            MarkerLayer(markers: [
              Marker(width: 60, height: 60, point: _rider, child: _riderPin()),
              Marker(width: 60, height: 60, point: widget.orderLocation, child: _destPin()),
            ]),
          ],
        )),
      ),
    ]),
  );

  Widget _riderPin() => AnimatedBuilder(
    animation: _pulseA,
    builder: (_, __) => Stack(alignment: Alignment.center, children: [
      Transform.scale(scale: _pulseA.value,
          child: Container(width: 56, height: 56,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _T.orange.withOpacity(0.2),
                  border: Border.all(color: _T.orange.withOpacity(0.5), width: 2)))),
      Container(width: 36, height: 36,
          decoration: const BoxDecoration(shape: BoxShape.circle,
              gradient: LinearGradient(colors: [_T.orange, _T.orangeDeep],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: const Icon(Icons.directions_bike, color: Colors.white, size: 18)),
    ]),
  );

  Widget _destPin() => Container(width: 40, height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: _T.red,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(color: _T.red.withOpacity(0.5), blurRadius: 8)]),
      child: const Icon(Icons.home_rounded, color: Colors.white, size: 20));

  // ── Customer ────────────────────────────────────────────────
  Widget _customerCard(_T t) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: t.card, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: t.bord),
      boxShadow: [BoxShadow(color: t.sh, blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.person_rounded, color: _T.orange, size: 18),
        const SizedBox(width: 8),
        Text("Customer Details", style: TextStyle(color: t.tp, fontSize: 15,
            fontWeight: FontWeight.w700, letterSpacing: -0.3)),
      ]),
      const SizedBox(height: 18),
      _info(t, Icons.person_outline_rounded, "Name",
          widget.customerName.isNotEmpty ? widget.customerName : "Not provided"),
      Divider(height: 1, color: t.bord),
      _info(t, Icons.phone_rounded, "Phone",
          widget.customerPhone.isNotEmpty ? widget.customerPhone : "Not provided"),
      Divider(height: 1, color: t.bord),
      _info(t, Icons.location_on_rounded, "Address", widget.customerAddress),
      Divider(height: 1, color: t.bord),
      _info(t, Icons.receipt_long_rounded, "Bill Amount",
          widget.billAmount.isNotEmpty ? "Rs ${widget.billAmount}" : "Not provided",
          vc: _T.green),
    ]),
  );

  Widget _info(_T t, IconData icon, String label, String value, {Color? vc}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: _T.orange, size: 16)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: t.ts, fontSize: 11, letterSpacing: 0.3)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(color: vc ?? t.tp, fontSize: 14, fontWeight: FontWeight.w600)),
          ])),
        ]),
      );

  // ── Timeline ────────────────────────────────────────────────
  Widget _timeline(_T t) {
    final steps = [
      {"label": "Order Placed",      "done": true},
      {"label": "Processing",        "done": true},
      {"label": "Out for Delivery",  "done": true},
      {"label": "Delivered",         "done": false},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.card, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.bord),
        boxShadow: [BoxShadow(color: t.sh, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.timeline_rounded, color: _T.orange, size: 18),
          const SizedBox(width: 8),
          Text("Order Progress", style: TextStyle(color: t.tp, fontSize: 15,
              fontWeight: FontWeight.w700, letterSpacing: -0.3)),
        ]),
        const SizedBox(height: 20),
        Row(children: List.generate(steps.length, (i) {
          final done   = steps[i]["done"] as bool;
          final isLast = i == steps.length - 1;
          final active = !done && (i == 0 || (steps[i - 1]["done"] as bool));
          return Expanded(child: Row(children: [
            Expanded(child: Column(children: [
              Container(width: 32, height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: done
                      ? const LinearGradient(colors: [_T.green, Color(0xFF16A34A)])
                      : active
                      ? const LinearGradient(colors: [_T.orange, _T.orangeDeep])
                      : null,
                  color: done || active ? null : t.surf,
                  border: Border.all(
                      color: done ? _T.green : active ? _T.orange : t.bord, width: 2),
                  boxShadow: done || active
                      ? [BoxShadow(color: (done ? _T.green : _T.orange).withOpacity(0.4), blurRadius: 8)]
                      : null,
                ),
                child: Icon(
                    done ? Icons.check_rounded : active ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: done || active ? Colors.white : t.ts, size: 16),
              ),
              const SizedBox(height: 8),
              Text(steps[i]["label"] as String,
                  style: TextStyle(
                    color: done ? t.tp : active ? _T.orange : t.ts,
                    fontSize: 10,
                    fontWeight: done || active ? FontWeight.w600 : FontWeight.w400,
                  ), textAlign: TextAlign.center),
            ])),
            if (!isLast)
              Expanded(child: Container(height: 2,
                  margin: const EdgeInsets.only(bottom: 26),
                  decoration: BoxDecoration(
                    gradient: done ? const LinearGradient(colors: [_T.green, _T.green]) : null,
                    color: done ? null : t.bord,
                    borderRadius: BorderRadius.circular(2),
                  ))),
          ]));
        })),
      ]),
    );
  }

  // ── Actions ─────────────────────────────────────────────────
  Widget _actions(_T t) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _btn(t, "Call Customer", Icons.call_rounded, _T.blue, () {}),
      const SizedBox(width: 12),
      _btn(t, "Assign Rider", Icons.directions_bike_rounded, _T.green, () {}),
    ],
  );

  Widget _btn(_T t, String label, IconData icon, Color c, VoidCallback onTap) =>
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: c.withOpacity(0.18),
            highlightColor: c.withOpacity(0.10),
            child: Ink(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: c.withOpacity(t.dark ? 0.10 : 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.withOpacity(0.35)),
                boxShadow: [BoxShadow(color: c.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, color: c, size: 17),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      );
}