import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_bookings_screen.dart';
import '../theme.dart';

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
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.success, size: 30),
              SizedBox(width: 10),
              Text('Payment Successful!', style: TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your booking has been confirmed.', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📍 ${widget.bookingData['lockerName']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text('👜 ${widget.bookingData['bagSize']} bag • ${widget.bookingData['duration']} hours', style: const TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 4),
                    Text('📅 ${widget.bookingData['date']} at ${widget.bookingData['time']}', style: const TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Text('💰 Total: ₹${widget.bookingData['totalPrice'].toStringAsFixed(0)}', 
                         style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
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
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
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
              child: const Text('VIEW BOOKINGS', style: TextStyle(color: AppTheme.primary)),
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
        title: const Text('Payment', style: TextStyle(color: AppTheme.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FF), Color(0xFFF0F2FF)],
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
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.smallShadow,
                ),
                child: Column(
                  children: [
                    const Icon(Icons.payment, size: 50, color: AppTheme.primary),
                    const SizedBox(height: 12),
                    const Text('Payment Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
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
                    const Divider(color: Color(0xFFE8E8F0)),
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
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.smallShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
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
                    backgroundColor: AppTheme.primary,
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
                child: const Text('Cancel', style: TextStyle(color: AppTheme.textMuted)),
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
      title: Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
      secondary: Icon(icon, color: AppTheme.primary),
      activeColor: AppTheme.primary,
    );
  }
  
  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppTheme.primary : AppTheme.textSecondary)),
        Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppTheme.primary : AppTheme.textPrimary)),
      ],
    );
  }
}
