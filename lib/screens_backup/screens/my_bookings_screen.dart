import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> _bookings = [];
  
  @override
  void initState() {
    super.initState();
    _loadBookings();
  }
  
  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];
    setState(() {
      _bookings = bookingsJson.map((json) {
        final parts = json.split('|');
        return {
          'id': parts[0],
          'lockerName': parts[1],
          'location': parts[2],
          'bagSize': parts[3],
          'duration': parts[4],
          'totalPrice': double.parse(parts[5]),
          'date': parts[6],
          'time': parts[7],
          'status': parts[8],
        };
      }).toList();
    });
  }
  
  Future<void> _cancelBooking(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        backgroundColor: const Color(0xFF2A2F4A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _bookings.removeAt(index);
                _saveBookings();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled'), backgroundColor: Colors.orange),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = _bookings.map((booking) {
      return '${booking['id']}|${booking['lockerName']}|${booking['location']}|${booking['bagSize']}|${booking['duration']}|${booking['totalPrice']}|${booking['date']}|${booking['time']}|${booking['status']}';
    }).toList();
    await prefs.setStringList('bookings', bookingsJson);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: _bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: Color(0xFF6B7280)),
                  SizedBox(height: 16),
                  Text('No bookings yet', style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Book a locker to see it here', style: TextStyle(color: Color(0xFF6B7280))),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2F4A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF0A84FF).withOpacity(0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  booking['lockerName'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                child: const Text('CONFIRMED', style: TextStyle(fontSize: 11, color: Colors.green)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                child: Text(booking['location'], style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 4),
                            Container(
                              child: Text('${booking['bagSize']} bag', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.timer, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 4),
                            Container(
                              child: Text('${booking['duration']} hours', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 4),
                            Container(
                              child: Text(booking['date'], style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 4),
                            Container(
                              child: Text(booking['time'], style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFF3A3F5A)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                            Container(
                              child: Text(
                                '₹${booking['totalPrice'].toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A84FF)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _cancelBooking(index),
                            icon: const Icon(Icons.cancel, size: 16),
                            label: const Text('CANCEL BOOKING'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
