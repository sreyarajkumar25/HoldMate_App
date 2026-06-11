import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'booking_screen.dart';

class LockerLocation {
  final String id;
  final String name;
  final String address;
  final String distance;
  final bool isAvailable;
  final int basePrice;
  final double rating;

  LockerLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.isAvailable,
    required this.basePrice,
    required this.rating,
  });
}

class LocationsScreen extends StatefulWidget {
  final String selectedArea;

  const LocationsScreen({super.key, required this.selectedArea});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late List<LockerLocation> _locations;
  String _searchQuery = '';

  final List<String> _peelameduLocations = [
    'Avinashi Road', 'Brookefields Mall', 'Fun Republic Mall',
    'Kovai Medical Center', 'PSG College of Technology', 'CODISSIA Complex',
    'Prozone Mall', 'SITRA', 'Hope College', 'Kumaraguru College',
  ];

  @override
  void initState() {
    super.initState();
    _generateRandomLocations();
  }

  void _generateRandomLocations() {
    final random = Random();
    _locations = [];
    for (var i = 0; i < _peelameduLocations.length; i++) {
      _locations.add(LockerLocation(
        id: i.toString(),
        name: _peelameduLocations[i],
        address: '${_peelameduLocations[i]}, ${widget.selectedArea}, Coimbatore',
        distance: '${random.nextInt(20) + 1} min walk',
        isAvailable: random.nextBool(),
        basePrice: 15 + random.nextInt(20),
        rating: 4.0 + random.nextDouble(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLocations = _searchQuery.isEmpty
        ? _locations
        : _locations.where((loc) =>
            loc.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lockers in ${widget.selectedArea}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search locations...',
                    hintStyle: TextStyle(color: AppTheme.textHint),
                    prefixIcon: Icon(Icons.search, color: AppTheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceLight,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = filteredLocations[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.smallShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: location.isAvailable
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(
                                      lockerName: location.name,
                                      location: location.address,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          location.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.star, size: 14, color: Colors.amber[600]),
                                            const SizedBox(width: 4),
                                            Text(
                                              location.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: location.isAvailable
                                          ? AppTheme.success.withOpacity(0.15)
                                          : AppTheme.danger.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      location.isAvailable ? 'Available' : 'Full',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: location.isAvailable ? AppTheme.success : AppTheme.danger,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 14, color: AppTheme.textHint),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      location.address,
                                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.directions_walk, size: 14, color: AppTheme.textHint),
                                  const SizedBox(width: 4),
                                  Text(
                                    location.distance,
                                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '₹${location.basePrice}/hr',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}