class Dish {
  final int id;
  final int menuId;
  final String name;
  final String description;
  final double price;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  Dish({
    required this.id,
    required this.menuId,
    required this.name,
    required this.description,
    required this.price,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as int,
      menuId: json['menu_id'] as int,
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
      'menu_id': menuId,
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
