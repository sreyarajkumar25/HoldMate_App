class Booking {
  final String id;
  final String lockerName;
  final String location;
  final String date;
  final String time;
  final double price;
  final String status;
  
  Booking({
    required this.id,
    required this.lockerName,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lockerName': lockerName,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'status': status,
    };
  }
  
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      lockerName: map['lockerName'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
    );
  }
}
