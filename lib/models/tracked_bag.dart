
class TrackedBag {
  final String id;
  final String name;
  final String description;
  final String? deviceId;
  final String status;
  final List<LocationPoint> locationHistory;
  final DateTime lastUpdated;
  final String? imageUrl;
  
  TrackedBag({
    required this.id,
    required this.name,
    required this.description,
    this.deviceId,
    this.status = 'active',
    this.locationHistory = const [],
    required this.lastUpdated,
    this.imageUrl,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deviceId': deviceId,
      'status': status,
      'locationHistory': locationHistory.map((l) => l.toMap()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
  
  factory TrackedBag.fromMap(Map<String, dynamic> map) {
    return TrackedBag(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      deviceId: map['deviceId'],
      status: map['status'],
      locationHistory: (map['locationHistory'] as List)
          .map((l) => LocationPoint.fromMap(l))
          .toList(),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      imageUrl: map['imageUrl'],
    );
  }
  
  TrackedBag copyWith({
    String? id,
    String? name,
    String? description,
    String? deviceId,
    String? status,
    List<LocationPoint>? locationHistory,
    DateTime? lastUpdated,
    String? imageUrl,
  }) {
    return TrackedBag(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      locationHistory: locationHistory ?? this.locationHistory,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class LocationPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;
  final double? speed;
  
  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.speed,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
      'speed': speed,
    };
  }
  
  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    return LocationPoint(
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.parse(map['timestamp']),
      accuracy: map['accuracy'],
      speed: map['speed'],
    );
  }
}
