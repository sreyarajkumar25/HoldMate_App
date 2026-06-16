import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locations_screen.dart';
import 'my_bookings_screen.dart';
import 'map_screen.dart';
import 'bag_tracking_screen.dart';
import 'booking_screen.dart';
import 'gps_map_screen.dart';
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
        backgroundColor: AppTheme.surface,
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
        backgroundColor: AppTheme.surface,
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
        title: Text(_currentLanguage == 'ta' ? 'Find Lockers' : 'Find Lockers'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.shopping_bag, color: AppTheme.primary), onPressed: _navigateToBagTracking),
          IconButton(icon: const Icon(Icons.map, color: AppTheme.primary), onPressed: _navigateToMap),
          IconButton(icon: const Icon(Icons.language, color: AppTheme.primary), onPressed: _showLanguageDialog),
          IconButton(icon: const Icon(Icons.logout, color: AppTheme.error), onPressed: _logout),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FF), Color(0xFFF0F2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _currentTab == 0
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header with Greeting ──
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $_userName! 👋',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: AppTheme.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Peelamedu, Coimbatore',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.primary,
                          child: Text(
                            _userName.isNotEmpty ? _userName[0].toUpperCase() : 'G',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Search Bar ──
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.smallShadow,
                      ),
                      child: const TextField(
                        style: TextStyle(color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search locker locations...',
                          hintStyle: TextStyle(color: AppTheme.textHint),
                          prefixIcon: Icon(Icons.search, color: AppTheme.primary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Quick Actions ──
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.backpack_rounded,
                            label: 'Book a Locker',
                            color: AppTheme.primary,
                            onTap: () => setState(() => _currentTab = 1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.receipt_long_rounded,
                            label: 'My Bookings',
                            color: AppTheme.secondary,
                            onTap: () => setState(() => _currentTab = 2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.shopping_bag,
                            label: 'Track Bag',
                            color: AppTheme.accent,
                            onTap: _navigateToBagTracking,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Recommended Lockers ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🔒 Recommended Lockers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See all',
                            style: TextStyle(color: AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Locker List ──
                    ...coimbatoreLockers.map((locker) => _buildLockerCard(locker)),
                  ],
                ),
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

  Widget _buildLockerCard(Map<String, dynamic> locker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.smallShadow,
        border: Border.all(
          color: locker['available'] == true ? AppTheme.primary.withOpacity(0.2) : Colors.transparent,
          width: 1,
        ),
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
        title: Text(
          locker['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locker['address'],
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${locker['rating']}',
                  style: const TextStyle(fontSize: 12, color: Colors.amber),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 12, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                const Text(
                  '24/7 Access',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '₹${locker['price']}/hr',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              locker['available'] ? 'Available' : 'Full',
              style: TextStyle(
                fontSize: 10,
                color: locker['available'] ? AppTheme.success : AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Card Widget ──
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.smallShadow,
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
