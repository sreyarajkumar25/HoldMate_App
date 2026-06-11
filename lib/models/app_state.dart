import 'booking.dart';

class AppState {
  static String _userName = '';
  static String _userEmail = '';
  static String _userPhone = '';
  static bool _isLoggedIn = false;
  static List<Booking> _bookings = [];
  
  static String get userName => _userName;
  static String get userEmail => _userEmail;
  static String get userPhone => _userPhone;
  static bool get isLoggedIn => _isLoggedIn;
  static List<Booking> get bookings => _bookings;
  
  static set userName(String name) {
    _userName = name.trim();
    if (_userName.isNotEmpty) {
      _isLoggedIn = true;
    }
  }
  
  static set userEmail(String email) {
    _userEmail = email.trim();
  }
  
  static set userPhone(String phone) {
    _userPhone = phone.trim();
  }
  
  static void addBooking(Booking booking) {
    _bookings.insert(0, booking);
  }
  
  static void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].status = 'cancelled';
    }
  }
  
  static void clear() {
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _isLoggedIn = false;
    _bookings.clear();
  }
}