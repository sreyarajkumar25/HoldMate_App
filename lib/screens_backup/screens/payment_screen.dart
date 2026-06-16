import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_bookings_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  
  const PaymentScreen({super.key, required this.bookingData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String _selectedMethod = 'Card';
  
  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];
    
    final bookingId = DateTime.now().millisecondsSinceEpoch.toString();
    final newBooking = '${bookingId}|${widget.bookingData['lockerName']}|${widget.bookingData['location']}|${widget.bookingData['bagSize']}|${widget.bookingData['duration']}|${widget.bookingData['totalPrice']}|${widget.bookingData['date']}|${widget.bookingData['time']}|confirmed';
    
    bookingsJson.add(newBooking);
    await prefs.setStringList('bookings', bookingsJson);
    
    setState(() => _isProcessing = false);
    
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Payment Successful!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your booking has been confirmed.'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2F4A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📍 ${widget.bookingData['lockerName']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('👜 ${widget.bookingData['bagSize']} bag • ${widget.bookingData['duration']} hours', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text('📅 ${widget.bookingData['date']} at ${widget.bookingData['time']}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text('💰 Total: ₹${widget.bookingData['totalPrice'].toStringAsFixed(0)}', 
                         style: const TextStyle(color: Color(0xFF0A84FF), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A84FF)),
              child: const Text('GO TO HOME'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
                );
              },
              child: const Text('VIEW BOOKINGS', style: TextStyle(color: Color(0xFF0A84FF))),
            ),
          ],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final data = widget.bookingData;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1F3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2F4A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.payment, size: 50, color: Color(0xFF0A84FF)),
                    const SizedBox(height: 12),
                    const Text('Payment Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildRow('Locker', data['lockerName']),
                    const SizedBox(height: 8),
                    _buildRow('Location', data['location']),
                    const SizedBox(height: 8),
                    _buildRow('Bag Size', '${data['bagSize']} ${_getBagIcon(data['bagSize'])}'),
                    const SizedBox(height: 8),
                    _buildRow('Duration', '${data['duration']} hour(s)'),
                    const SizedBox(height: 8),
                    _buildRow('Price per hour', '₹${data['pricePerHour'].toStringAsFixed(0)}'),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFF3A3F5A)),
                    const SizedBox(height: 8),
                    _buildRow('Total Amount', '₹${data['totalPrice'].toStringAsFixed(0)}', isTotal: true),
                    const SizedBox(height: 8),
                    _buildRow('Date & Time', '${data['date']} at ${data['time']}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2F4A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 12),
                    _buildPaymentMethod('Credit/Debit Card', Icons.credit_card, 'Card'),
                    _buildPaymentMethod('Google Pay', Icons.payment, 'Google Pay'),
                    _buildPaymentMethod('PhonePe', Icons.phone_android, 'PhonePe'),
                    _buildPaymentMethod('Cash', Icons.money, 'Cash'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A84FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isProcessing
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('PAY NOW', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getBagIcon(String size) {
    switch(size) {
      case 'Small': return '🧳';
      case 'Medium': return '🎒';
      case 'Large': return '🧰';
      case 'Extra Large': return '📦';
      default: return '👜';
    }
  }
  
  Widget _buildPaymentMethod(String title, IconData icon, String value) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedMethod,
      onChanged: (v) => setState(() => _selectedMethod = v!),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      secondary: Icon(icon, color: const Color(0xFF0A84FF)),
      activeColor: const Color(0xFF0A84FF),
    );
  }
  
  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? const Color(0xFF0A84FF) : const Color(0xFF6B7280))),
        Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? const Color(0xFF0A84FF) : Colors.white)),
      ],
    );
  }
}
