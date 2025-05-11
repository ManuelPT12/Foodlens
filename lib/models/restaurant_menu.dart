class RestaurantMenu {
  final int id;
  final int userId;
  final String restaurantName;
  final String location;
  final String imageUrl;
  final DateTime scannedAt;

  RestaurantMenu({
    required this.id,
    required this.userId,
    required this.restaurantName,
    required this.location,
    required this.imageUrl,
    required this.scannedAt,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      restaurantName: json['restaurant_name'] as String,
      location: json['location'] as String,
      imageUrl: json['image_url'] as String,
      scannedAt: DateTime.parse(json['scanned_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_name': restaurantName,
      'location': location,
      'image_url': imageUrl,
      'scanned_at': scannedAt.toIso8601String(),
    };
  }
}
