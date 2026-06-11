import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/booking.dart';
import '../models/app_state.dart';
import 'receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String lockerName;
  final String location;
  final String bagSize;
  final int hours;
  final double basePrice;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.lockerName,
    required this.location,
    required this.bagSize,
    required this.hours,
    required this.basePrice,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'UPI';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'UPI',
      'subtitle': 'Google Pay, PhonePe, Paytm',
      'icon': Icons.qr_code_scanner,
    },
    {
      'name': 'Credit/Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card,
    },
    {
      'name': 'Net Banking',
      'subtitle': 'All major banks',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Wallet',
      'subtitle': 'Paytm, Amazon Pay',
      'icon': Icons.account_balance_wallet,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Colors.white),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Amount Card
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.glowShadow,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${widget.totalAmount.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Payment Methods Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Payment Methods List
                    ..._paymentMethods.map((method) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedPaymentMethod == method['name'] 
                            ? AppTheme.primary.withOpacity(0.15) 
                            : AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedPaymentMethod == method['name'] 
                              ? AppTheme.primary 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: RadioListTile<String>(
                        title: Text(
                          method['name'],
                          style: TextStyle(
                            color: _selectedPaymentMethod == method['name'] 
                                ? AppTheme.primary 
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          method['subtitle'],
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        secondary: Icon(
                          method['icon'],
                          color: _selectedPaymentMethod == method['name'] 
                              ? AppTheme.primary 
                              : AppTheme.textHint,
                        ),
                        value: method['name'],
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                        activeColor: AppTheme.primary,
                      ),
                    )),
                    
                    // QR Code Section (only for UPI)
                    if (_selectedPaymentMethod == 'UPI' && !_isProcessing)
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Scan QR Code to Pay',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppTheme.glowShadow,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  size: 100,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'UPI ID: holdmate@okhdfcbank',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Amount: ₹${widget.totalAmount.toInt()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Pay Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: AppTheme.softShadow,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'PAY NOW',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Create booking
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      lockerName: widget.lockerName,
      location: widget.location,
      bagSize: widget.bagSize,
      hours: widget.hours,
      basePricePerHour: widget.basePrice,
      totalAmount: widget.totalAmount,
      paymentMethod: _selectedPaymentMethod,
      bookingTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: widget.hours)),
      status: 'active',
      qrCodeUrl: 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=booking_${DateTime.now().millisecondsSinceEpoch}',
    );

    AppState.addBooking(booking);

    setState(() {
      _isProcessing = false;
    });

    // Navigate to receipt
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(booking: booking),
      ),
    );
  }
}