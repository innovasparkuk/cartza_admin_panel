import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

class _AddOrderPage2State extends State<AddOrderPage2> {
  static const Color primaryColor = Color(0xFFFF6F00);
  static const Color secondaryColor = Color(0xFF212121);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color deliveryOrange = Color(0xFFFF6F00);
  static const Color darkOrange = Color(0xFFE65100);

  // Static rider position - will never change
  final LatLng _riderLocation = const LatLng(24.8700, 67.0100);
  bool _isRiderAvailable = true; // Just for UI status

  final Distance distanceCalculator = const Distance();

  // Calculate distance once (static)
  double get _calculateDistance {
    return distanceCalculator.as(LengthUnit.Kilometer, _riderLocation, widget.orderLocation);
  }

  // Calculate ETA once (static)
  int get _estimateTime {
    double distance = _calculateDistance;
    return (distance / 30 * 60).round() + 5; // 30 km/h average speed + 5 min buffer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${widget.orderId}', style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text('Live Tracking', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _isRiderAvailable ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  _isRiderAvailable ? Icons.check_circle : Icons.timer,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  _isRiderAvailable ? 'Active' : 'Busy',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Delivery Stats Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, deliveryOrange.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Static distance visualization
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: deliveryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: deliveryOrange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: deliveryOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_calculateDistance.toStringAsFixed(1)} km',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: deliveryOrange,
                                  ),
                                ),
                                Text(
                                  'Fixed Distance from Rider',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: deliveryOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$_estimateTime min',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: deliveryOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.directions_bike,
                          value: 'Rider ${_riderLocation.latitude.toStringAsFixed(4)}',
                          label: 'Rider Position',
                          color: deliveryOrange,
                        ),
                        _buildStatItem(
                          icon: Icons.location_on,
                          value: 'Dest ${widget.orderLocation.latitude.toStringAsFixed(4)}',
                          label: 'Destination',
                          color: Colors.red,
                        ),
                        _buildStatItem(
                          icon: Icons.straight,
                          value: '${_calculateDistance.toStringAsFixed(1)} km',
                          label: 'Static Distance',
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Customer & Order Details
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.orange.shade50],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person, color: primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Customer Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Name', widget.customerName.isNotEmpty ? widget.customerName : 'Not provided', Icons.person_outline),
                    _buildDetailRow('Phone', widget.customerPhone.isNotEmpty ? widget.customerPhone : 'Not provided', Icons.phone),
                    _buildDetailRow('Address', widget.customerAddress, Icons.home),
                    _buildDetailRow('Amount', widget.billAmount.isNotEmpty ? 'Rs ${widget.billAmount}' : 'Not provided', Icons.currency_rupee),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Static Tracking Map
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: deliveryOrange.withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.map, color: primaryColor, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Delivery Route Map',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: deliveryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),

                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 320,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              (widget.orderLocation.latitude + _riderLocation.latitude) / 2,
                              (widget.orderLocation.longitude + _riderLocation.longitude) / 2,
                            ),
                            initialZoom: 12,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              tileDisplay: const TileDisplay.fadeIn(),
                            ),
                            // Route line - Static
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [_riderLocation, widget.orderLocation],
                                  color: deliveryOrange.withOpacity(0.7),
                                  strokeWidth: 5.0,
                                  borderStrokeWidth: 2.0,
                                  borderColor: Colors.white,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                // Static Rider Marker
                                Marker(
                                  width: 70,
                                  height: 70,
                                  point: _riderLocation,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: deliveryOrange.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: deliveryOrange, width: 4),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(Icons.directions_bike, color: deliveryOrange, size: 36),
                                        Positioned(
                                          bottom: -2,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: deliveryOrange,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'RIDER',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Static Destination Marker
                                Marker(
                                  width: 70,
                                  height: 70,
                                  point: widget.orderLocation,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.red, width: 4),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.red, size: 36),
                                        Positioned(
                                          bottom: -2,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'DELIVER',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Distance Info Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: deliveryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: deliveryOrange.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fixed Distance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '${_calculateDistance.toStringAsFixed(2)} kilometers',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: deliveryOrange,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Est. Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '$_estimateTime minutes',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMapLegend('Rider Position', deliveryOrange, Icons.directions_bike),
                        _buildMapLegend('Delivery Point', Colors.red, Icons.location_on),
                        _buildMapLegend('Static Route', deliveryOrange.withOpacity(0.7), Icons.alt_route),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [deliveryOrange.withOpacity(0.1), deliveryOrange.withOpacity(0.05)],
                    ),
                    border: Border.all(color: deliveryOrange.withOpacity(0.3)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.call, color: deliveryOrange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Call Customer',
                          style: TextStyle(
                            color: deliveryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
                    ),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.directions_bike, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Assign Rider',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String value, required String label, required Color color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: secondaryColor,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: deliveryOrange.withOpacity(0.7), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegend(String text, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: secondaryColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}