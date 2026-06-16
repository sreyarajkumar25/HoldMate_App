import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static String userName = '';
  static String userEmail = '';
  static String userPhone = '';
  static bool isLoggedIn = false;
  static List<Map<String, dynamic>> bookings = [];
  
  static void setUser(String name, String email, String phone) {
    userName = name;
    userEmail = email;
    userPhone = phone;
    isLoggedIn = true;
  }
  
  static void clear() {
    userName = '';
    userEmail = '';
    userPhone = '';
    isLoggedIn = false;
    bookings = [];
  }
  
  static void addBooking(Map<String, dynamic> booking) {
    bookings.add(booking);
  }
  
  static void cancelBooking(String bookingId) {
    bookings.removeWhere((booking) => booking['id'] == bookingId);
  }
}
