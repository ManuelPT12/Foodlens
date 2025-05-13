class MealLog {
  final int id;
  final int userId;
  final DateTime mealDate;
  final String mealType;
  final String dishName;
  final String description;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? imageUrl;
  final DateTime createdAt;

  MealLog({
    required this.id,
    required this.userId,
    required this.mealDate,
    required this.mealType,
    required this.dishName,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
    required this.createdAt,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      mealDate: DateTime.parse(json['meal_date'] as String),
      mealType: json['meal_type'] as String,
      dishName: json['dish_name'] as String,
      description: json['description'] as String,
      calories: json['calories'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'meal_date': mealDate.toIso8601String(),
      'meal_type': mealType,
      'dish_name': dishName,
      'description': description,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      if (imageUrl != null) 'image_url': imageUrl,
      // 'created_at' normalmente lo gestiona el servidor
    };
  }
}
