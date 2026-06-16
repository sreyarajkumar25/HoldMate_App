import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locations_screen.dart';
import 'my_bookings_screen.dart';
import 'map_screen.dart';
import 'gps_map_screen.dart';
import 'bag_tracking_screen.dart';
import 'booking_screen.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  String _currentLanguage = 'en';
  String _userName = 'Guest User';

  final List<Map<String, dynamic>> coimbatoreLockers = const [
    {'name': 'Coimbatore Railway Station', 'address': 'Platform 1, Near Waiting Hall', 'price': 20, 'available': true, 'rating': 4.8},
    {'name': 'Gandhipuram Bus Stand', 'address': 'Main Entrance, Left Side', 'price': 20, 'available': true, 'rating': 4.6},
    {'name': 'Peelamedu Metro Station', 'address': 'Concourse Area, Near Exit B', 'price': 20, 'available': true, 'rating': 4.7},
    {'name': 'Brookefields Mall', 'address': 'Ground Floor, Near Food Court', 'price': 25, 'available': true, 'rating': 4.9},
    {'name': 'Prozone Mall', 'address': 'Parking Area, Level 1', 'price': 25, 'available': false, 'rating': 4.5},
    {'name': 'RS Puram Post Office', 'address': 'Near Bus Stop, Cross Cut Road', 'price': 15, 'available': true, 'rating': 4.4},
    {'name': 'Saibaba Colony', 'address': 'Near Senthil Super Market', 'price': 15, 'available': true, 'rating': 4.3},
    {'name': 'Singanallur Bus Terminus', 'address': 'Platform 3, Near Ticket Counter', 'price': 18, 'available': true, 'rating': 4.2},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadUserData();
  }
  
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _currentLanguage = prefs.getString('language_code') ?? 'en');
  }
  
  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    setState(() => _currentLanguage = languageCode);
  }
  
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _userName = prefs.getString('user_name') ?? 'Guest User');
  }

  void _navigateToMap() => Navigator.push(context, MaterialPageRoute(builder: (context) => const GpsMapScreen()));
  void _navigateToBagTracking() => Navigator.push(context, MaterialPageRoute(builder: (context) => const BagTrackingScreen()));
  
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentLanguage == 'ta' ? 'மொழியைத் தேர்ந்தெடுக்கவும்' : 'Select Language'),
        backgroundColor: AppTheme.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag, color: AppTheme.primary),
              title: const Text('English'),
              trailing: _currentLanguage == 'en' ? const Icon(Icons.check, color: AppTheme.success) : null,
              onTap: () { _changeLanguage('en'); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: AppTheme.secondary),
              title: const Text('தமிழ்'),
              trailing: _currentLanguage == 'ta' ? const Icon(Icons.check, color: AppTheme.success) : null,
              onTap: () { _changeLanguage('ta'); Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }
  
  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        backgroundColor: AppTheme.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_name');
              await prefs.remove('user_email');
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentLanguage == 'ta' ? 'கோயம்புத்தூரில் பூட்டறைகள்' : 'Find Lockers in Coimbatore'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.shopping_bag, color: AppTheme.textPrimary), onPressed: _navigateToBagTracking),
          IconButton(icon: const Icon(Icons.map, color: AppTheme.textPrimary), onPressed: _navigateToMap),
          IconButton(icon: const Icon(Icons.language, color: AppTheme.textPrimary), onPressed: _showLanguageDialog),
          IconButton(icon: const Icon(Icons.logout, color: AppTheme.error), onPressed: _logout),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF14141D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _currentTab == 0
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: coimbatoreLockers.length,
                itemBuilder: (context, index) {
                  final locker = coimbatoreLockers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.smallShadow,
                    ),
                    child: ListTile(
                      onTap: locker['available'] == true ? () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(
                          lockerName: locker['name'],
                          location: locker['address'],
                          basePrice: locker['price'].toDouble(),
                        )));
                      } : null,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lock_outline, color: Colors.white),
                      ),
                      title: Text(locker['name'], style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: Text('${locker['address']} • ⭐ ${locker['rating']}', style: const TextStyle(color: AppTheme.textSecondary)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('₹${locker['price']}/hr', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            locker['available'] ? 'Available' : 'Full',
                            style: TextStyle(fontSize: 10, color: locker['available'] ? AppTheme.success : AppTheme.error),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : (_currentTab == 1 ? LocationsScreen(selectedArea: 'Peelamedu') : MyBookingsScreen()),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: AppTheme.softShadow,
        ),
        child: NavigationBar(
          selectedIndex: _currentTab,
          onDestinationSelected: (index) => setState(() => _currentTab = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 70,
          indicatorColor: AppTheme.primary.withOpacity(0.2),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: _currentLanguage == 'ta' ? 'முகப்பு' : 'Home'),
            NavigationDestination(icon: const Icon(Icons.backpack_outlined), selectedIcon: const Icon(Icons.backpack_rounded), label: _currentLanguage == 'ta' ? 'முன்பதிவு' : 'Book'),
            NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), selectedIcon: const Icon(Icons.receipt_long_rounded), label: _currentLanguage == 'ta' ? 'முன்பதிவுகள்' : 'Bookings'),
          ],
        ),
      ),
    );
  }
}
