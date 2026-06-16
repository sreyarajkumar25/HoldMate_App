import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int _totalBookings = 0;
  int _completedBookings = 0;
  int _pendingBookings = 0;
  
  int get totalBookings => _totalBookings;
  int get completedBookings => _completedBookings;
  int get pendingBookings => _pendingBookings;
  
  void updateStats({
    int? total,
    int? completed,
    int? pending,
  }) {
    if (total != null) _totalBookings = total;
    if (completed != null) _completedBookings = completed;
    if (pending != null) _pendingBookings = pending;
    notifyListeners();
  }
}