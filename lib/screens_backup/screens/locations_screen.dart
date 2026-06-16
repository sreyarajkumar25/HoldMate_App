import 'package:flutter/material.dart';

class LocationsScreen extends StatelessWidget {
  final String selectedArea;
  const LocationsScreen({super.key, required this.selectedArea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_city, size: 80, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text('Select a location from Home screen', style: TextStyle(color: Colors.grey.shade400)),
        ],
      )),
    );
  }
}
