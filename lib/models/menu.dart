class Menu {
  final int id;
  final int restaurantId;
  final String name;
  final String imageUrl;
  final DateTime lastUpdated;

  Menu({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.imageUrl,
    required this.lastUpdated,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as int,
      restaurantId: json['restaurant_id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'image_url': imageUrl,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
