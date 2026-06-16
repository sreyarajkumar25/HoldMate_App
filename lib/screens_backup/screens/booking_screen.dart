import 'package:flutter/material.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final String lockerName;
  final String location;
  final double basePrice;
  
  const BookingScreen({
    super.key,
    required this.lockerName,
    required this.location,
    required this.basePrice,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _duration = 1;
  String _selectedBagSize = 'Small';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  
  final Map<String, double> _bagSizeMultipliers = {
    'Small': 1.0,
    'Medium': 1.5,
    'Large': 2.0,
    'Extra Large': 2.5,
  };
  
  final Map<String, String> _bagSizeIcons = {
    'Small': '🧳',
    'Medium': '🎒',
    'Large': '🧰',
    'Extra Large': '📦',
  };
  
  double get _pricePerHour => widget.basePrice * _bagSizeMultipliers[_selectedBagSize]!;
  double get _totalPrice => _pricePerHour * _duration;
  
  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  String _formatTime(TimeOfDay time) => '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Locker', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1F3A),
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
                decoration: BoxDecoration(color: const Color(0xFF2A2F4A), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    const Icon(Icons.lock_outline, size: 50, color: Color(0xFF0A84FF)),
                    const SizedBox(height: 12),
                    Text(widget.lockerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(widget.location, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF2A2F4A), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Bag Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBagSizeOption('Small', '🧳'),
                        const SizedBox(width: 8),
                        _buildBagSizeOption('Medium', '🎒'),
                        const SizedBox(width: 8),
                        _buildBagSizeOption('Large', '🧰'),
                        const SizedBox(width: 8),
                        _buildBagSizeOption('Extra Large', '📦'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF2A2F4A), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Duration (hours)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _duration > 1 ? () => setState(() => _duration--) : null,
                          icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF0A84FF), size: 40),
                        ),
                        Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(12)),
                          child: Text('$_duration', textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _duration++),
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF0A84FF), size: 40),
                        ),
                        const SizedBox(width: 8),
                        const Text('hour(s)', style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF2A2F4A), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _buildPriceRow('Bag Size', '$_selectedBagSize ${_bagSizeIcons[_selectedBagSize]}'),
                    const SizedBox(height: 8),
                    _buildPriceRow('Base Price/hr', '₹${widget.basePrice.toStringAsFixed(0)}'),
                    const SizedBox(height: 8),
                    _buildPriceRow('Size Multiplier', '${_bagSizeMultipliers[_selectedBagSize]}x'),
                    const SizedBox(height: 8),
                    _buildPriceRow('Final Price/hr', '₹${_pricePerHour.toStringAsFixed(0)}', highlight: true),
                    const SizedBox(height: 8),
                    _buildPriceRow('Duration', '$_duration hour(s)'),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFF3A3F5A)),
                    const SizedBox(height: 8),
                    _buildPriceRow('Total Amount', '₹${_totalPrice.toStringAsFixed(0)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(bookingData: {
                      'lockerName': widget.lockerName,
                      'location': widget.location,
                      'bagSize': _selectedBagSize,
                      'basePrice': widget.basePrice,
                      'pricePerHour': _pricePerHour,
                      'duration': _duration,
                      'totalPrice': _totalPrice,
                      'date': _formatDate(_selectedDate),
                      'time': _formatTime(_selectedTime),
                    })));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A84FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('BOOK NOW', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBagSizeOption(String size, String icon) {
    final isSelected = _selectedBagSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedBagSize = size),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0A84FF) : const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF0A84FF) : const Color(0xFF3A3F5A)),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                size,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF0A84FF) : (highlight ? const Color(0xFF0A84FF) : const Color(0xFF6B7280)),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF0A84FF) : (highlight ? const Color(0xFF0A84FF) : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
