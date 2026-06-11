class Booking {
  final String id;
  final String lockerName;
  final String location;
  final String bagSize;
  final int hours;
  final double basePricePerHour;
  final double totalAmount;
  final String paymentMethod;
  final DateTime bookingTime;
  final DateTime endTime;
  String status;
  final String qrCodeUrl;

  Booking({
    required this.id,
    required this.lockerName,
    required this.location,
    required this.bagSize,
    required this.hours,
    required this.basePricePerHour,
    required this.totalAmount,
    required this.paymentMethod,
    required this.bookingTime,
    required this.endTime,
    required this.status,
    required this.qrCodeUrl,
  });
}