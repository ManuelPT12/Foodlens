class MenuDish {
  final int id;
  final int restaurantMenuId;
  final String name;
  final String description;
  final double price;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  MenuDish({
    required this.id,
    required this.restaurantMenuId,
    required this.name,
    required this.description,
    required this.price,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MenuDish.fromJson(Map<String, dynamic> json) {
    return MenuDish(
      id: json['id'] as int,
      restaurantMenuId: json['restaurant_menu_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      calories: json['calories'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_menu_id': restaurantMenuId,
      'name': name,
      'description': description,
      'price': price,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
