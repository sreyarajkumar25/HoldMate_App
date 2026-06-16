import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

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
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No', style: TextStyle(color: AppTheme.textSecondary))),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _bookings.removeAt(index);
                _saveBookings();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled'), backgroundColor: AppTheme.warning),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
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
          colors: [Color(0xFFF8F9FF), Color(0xFFF0F2FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: _bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: AppTheme.textMuted),
                  SizedBox(height: 16),
                  Text('No bookings yet', style: TextStyle(fontSize: 18, color: AppTheme.textPrimary)),
                  SizedBox(height: 8),
                  Text('Book a locker to see it here', style: TextStyle(color: AppTheme.textMuted)),
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
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.smallShadow,
                    border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
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
                              child: SelectableText(
                                booking['lockerName'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                enableInteractiveSelection: false,
                                toolbarOptions: const ToolbarOptions(),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SelectableText(
                                'CONFIRMED',
                                style: const TextStyle(fontSize: 11, color: AppTheme.success),
                                enableInteractiveSelection: false,
                                toolbarOptions: const ToolbarOptions(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: SelectableText(
                                booking['location'],
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                enableInteractiveSelection: false,
                                toolbarOptions: const ToolbarOptions(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            SelectableText(
                              '${booking['bagSize']} bag',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              enableInteractiveSelection: false,
                              toolbarOptions: const ToolbarOptions(),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.timer, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            SelectableText(
                              '${booking['duration']} hours',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              enableInteractiveSelection: false,
                              toolbarOptions: const ToolbarOptions(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            SelectableText(
                              booking['date'],
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              enableInteractiveSelection: false,
                              toolbarOptions: const ToolbarOptions(),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            SelectableText(
                              booking['time'],
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              enableInteractiveSelection: false,
                              toolbarOptions: const ToolbarOptions(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFE8E8F0)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                            SelectableText(
                              '₹${booking['totalPrice'].toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                              enableInteractiveSelection: false,
                              toolbarOptions: const ToolbarOptions(),
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
                              foregroundColor: AppTheme.error,
                              side: const BorderSide(color: AppTheme.error),
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
