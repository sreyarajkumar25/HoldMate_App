import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class BagTrackingScreen extends StatefulWidget {
  const BagTrackingScreen({super.key});

  @override
  State<BagTrackingScreen> createState() => _BagTrackingScreenState();
}

class _BagTrackingScreenState extends State<BagTrackingScreen> {
  List<Map<String, dynamic>> _bags = [];
  Timer? _trackingTimer;
  int _selectedBagIndex = 0;
  
  final List<Map<String, dynamic>> _locations = const [
    {'name': 'Coimbatore Railway Station', 'lat': 11.0034, 'lng': 76.9712},
    {'name': 'Gandhipuram Bus Stand', 'lat': 11.0208, 'lng': 76.9575},
    {'name': 'Peelamedu Metro Station', 'lat': 11.0352, 'lng': 76.9975},
    {'name': 'Brookefields Mall', 'lat': 11.0295, 'lng': 76.9546},
    {'name': 'RS Puram', 'lat': 11.0085, 'lng': 76.9537},
    {'name': 'Singanallur', 'lat': 11.0085, 'lng': 77.0285},
  ];
  
  @override
  void initState() {
    super.initState();
    _autoAddDemoBag();
    _loadBags();
    _startAutomaticTracking();
  }
  
  void _autoAddDemoBag() async {
    final prefs = await SharedPreferences.getInstance();
    final bagsJson = prefs.getStringList('bags') ?? [];
    if (bagsJson.isEmpty) {
      final demoBag = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'My Travel Bag',
        'description': 'Auto-tracked bag',
        'status': 'tracking',
        'lastLocation': 'Coimbatore Railway Station',
        'locationIndex': 0,
        'lat': _locations[0]['lat'],
        'lng': _locations[0]['lng'],
      };
      bagsJson.add('${demoBag['id']}|${demoBag['name']}|${demoBag['description']}|${demoBag['status']}|${demoBag['lastLocation']}|${demoBag['locationIndex']}|${demoBag['lat']}|${demoBag['lng']}');
      await prefs.setStringList('bags', bagsJson);
    }
  }
  
  @override
  void dispose() {
    _trackingTimer?.cancel();
    super.dispose();
  }
  
  Future<void> _loadBags() async {
    final prefs = await SharedPreferences.getInstance();
    final bagsJson = prefs.getStringList('bags') ?? [];
    setState(() {
      _bags = bagsJson.map((json) {
        final parts = json.split('|');
        return {
          'id': parts[0],
          'name': parts[1],
          'description': parts[2],
          'status': parts.length > 3 ? parts[3] : 'tracking',
          'lastLocation': parts.length > 4 ? parts[4] : _locations[0]['name'],
          'locationIndex': parts.length > 5 ? int.parse(parts[5]) : 0,
          'lat': parts.length > 6 ? double.parse(parts[6]) : _locations[0]['lat'],
          'lng': parts.length > 7 ? double.parse(parts[7]) : _locations[0]['lng'],
        };
      }).toList();
    });
  }
  
  Future<void> _saveBags() async {
    final prefs = await SharedPreferences.getInstance();
    final bagsJson = _bags.map((bag) {
      return '${bag['id']}|${bag['name']}|${bag['description']}|${bag['status']}|${bag['lastLocation']}|${bag['locationIndex']}|${bag['lat']}|${bag['lng']}';
    }).toList();
    await prefs.setStringList('bags', bagsJson);
  }
  
  void _startAutomaticTracking() {
    _trackingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bags.isNotEmpty && mounted) {
        setState(() {
          for (int i = 0; i < _bags.length; i++) {
            if (_bags[i]['status'] == 'tracking') {
              int currentIndex = (_bags[i]['locationIndex'] as int);
              currentIndex = (currentIndex + 1) % _locations.length;
              _bags[i]['locationIndex'] = currentIndex;
              _bags[i]['lastLocation'] = _locations[currentIndex]['name'];
              _bags[i]['lat'] = _locations[currentIndex]['lat'];
              _bags[i]['lng'] = _locations[currentIndex]['lng'];
            }
          }
          _saveBags();
        });
      }
    });
  }
  
  LatLng _getCurrentLocation() {
    if (_bags.isNotEmpty && _selectedBagIndex < _bags.length) {
      return LatLng(_bags[_selectedBagIndex]['lat'], _bags[_selectedBagIndex]['lng']);
    }
    return const LatLng(11.0168, 76.9558);
  }
  
  List<LatLng> _getPathPoints() {
    List<LatLng> points = [];
    if (_bags.isNotEmpty && _selectedBagIndex < _bags.length) {
      final bag = _bags[_selectedBagIndex];
      final currentIndex = bag['locationIndex'] as int;
      for (int i = 0; i <= currentIndex; i++) {
        points.add(LatLng(_locations[i]['lat'], _locations[i]['lng']));
      }
    }
    return points;
  }
  
  @override
  Widget build(BuildContext context) {
    final currentBag = _bags.isNotEmpty && _selectedBagIndex < _bags.length 
        ? _bags[_selectedBagIndex] 
        : null;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Bag Tracking', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1F3A),
        actions: [
          if (_bags.isNotEmpty && _bags.length > 1)
            PopupMenuButton<String>(
              icon: const Icon(Icons.swap_vert, color: Colors.white),
              color: const Color(0xFF2A2F4A),
              onSelected: (String value) {
                setState(() {
                  _selectedBagIndex = int.parse(value);
                });
              },
              itemBuilder: (context) {
                return _bags.asMap().entries.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.key.toString(),
                    child: Text(entry.value['name'], style: const TextStyle(color: Colors.white)),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _bags.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFF6B7280)),
                    SizedBox(height: 16),
                    Text('No bags to track', style: TextStyle(fontSize: 18, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Add a bag from the + button or restart the app', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.green.withOpacity(0.2),
                    child: Row(
                      children: [
                        const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🟢 LIVE TRACKING: ${currentBag?['name']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('📍 ${currentBag?['lastLocation']}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                          child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: _getCurrentLocation(),
                        initialZoom: 13.0,
                        minZoom: 8.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.holdmate.app',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _getPathPoints(),
                              color: Colors.blue,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            if (currentBag != null)
                              Marker(
                                point: LatLng(currentBag['lat'], currentBag['lng']),
                                width: 80,
                                height: 80,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution('OpenStreetMap contributors'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2F4A),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.shopping_bag,
                                label: 'Bag',
                                value: currentBag?['name'] ?? 'N/A',
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.location_on,
                                label: 'Current Location',
                                value: currentBag?['lastLocation'] ?? 'N/A',
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.speed,
                                label: 'Status',
                                value: currentBag?['status'] == 'tracking' ? 'Moving' : 'Idle',
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.timer,
                                label: 'Last Update',
                                value: 'Just now',
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    if (_bags[_selectedBagIndex]['status'] == 'tracking') {
                                      _bags[_selectedBagIndex]['status'] = 'idle';
                                    } else {
                                      _bags[_selectedBagIndex]['status'] = 'tracking';
                                    }
                                    _saveBags();
                                  });
                                },
                                icon: Icon(_bags[_selectedBagIndex]['status'] == 'tracking' ? Icons.pause : Icons.play_arrow),
                                label: Text(_bags[_selectedBagIndex]['status'] == 'tracking' ? 'PAUSE' : 'RESUME'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _bags[_selectedBagIndex]['status'] == 'tracking' ? Colors.orange : Colors.green,
                                  side: BorderSide(color: _bags[_selectedBagIndex]['status'] == 'tracking' ? Colors.orange : Colors.green),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildInfoCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 2, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
