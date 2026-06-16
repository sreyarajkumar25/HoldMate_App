import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';
import '../models/locker.dart';

class BookingService {
  static const String _bookingsKey = 'bookings';
  static const String _activeBookingKey = 'active_booking';
  
  Future<void> saveBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    List<Booking> bookings = await getBookings();
    bool isAvailable = await isLockerAvailable(booking.lockerId, booking.date, booking.startTime, booking.endTime);
    if (!isAvailable) throw Exception('Locker not available');
    bookings.add(booking);
    await prefs.setStringList(_bookingsKey, bookings.map((b) => jsonEncode(b.toJson())).toList());
    await prefs.setString(_activeBookingKey, jsonEncode(booking.toJson()));
  }
  
  Future<List<Booking>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? bookingStrings = prefs.getStringList(_bookingsKey);
    if (bookingStrings == null || bookingStrings.isEmpty) return [];
    return bookingStrings.map((str) => Booking.fromJson(jsonDecode(str))).toList();
  }
  
  Future<Booking?> getActiveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    String? bookingString = prefs.getString(_activeBookingKey);
    if (bookingString == null) return null;
    try {
      return Booking.fromJson(jsonDecode(bookingString));
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Booking> bookings = await getBookings();
      bookings.removeWhere((booking) => booking.id == bookingId);
      await prefs.setStringList(_bookingsKey, bookings.map((b) => jsonEncode(b.toJson())).toList());
      String? activeBookingStr = prefs.getString(_activeBookingKey);
      if (activeBookingStr != null) {
        try {
          Booking activeBooking = Booking.fromJson(jsonDecode(activeBookingStr));
          if (activeBooking.id == bookingId) await prefs.remove(_activeBookingKey);
        } catch (e) {
          await prefs.remove(_activeBookingKey);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> cancelAndFreeLocker(String bookingId, String lockerId) async {
    try {
      bool cancelled = await cancelBooking(bookingId);
      if (cancelled) {
        final prefs = await SharedPreferences.getInstance();
        String? lockersJson = prefs.getString('lockers');
        if (lockersJson != null) {
          List<dynamic> lockersList = jsonDecode(lockersJson);
          List<Locker> lockers = lockersList.map((l) => Locker.fromJson(l)).toList();
          int index = lockers.indexWhere((l) => l.id == lockerId);
          if (index != -1) {
            lockers[index].isBooked = false;
            lockers[index].currentBookingId = null;
            lockers[index].bookedUntil = null;
            await prefs.setStringList('lockers', lockers.map((l) => jsonEncode(l.toJson())).toList());
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> isLockerAvailable(String lockerId, String date, String startTime, String endTime) async {
    List<Booking> bookings = await getBookings();
    List<Booking> lockerBookings = bookings.where((b) => b.lockerId == lockerId && b.date == date).toList();
    for (Booking existing in lockerBookings) {
      if (existing.startTime == startTime && existing.endTime == endTime) {
        return false;
      }
    }
    return true;
  }
  
  Future<void> clearAllBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookingsKey);
    await prefs.remove(_activeBookingKey);
  }
}
