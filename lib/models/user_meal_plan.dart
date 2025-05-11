class UserMealPlan {
  final int id;
  final int userId;
  final DateTime planDate;
  final int mealType;
  final String dishDescription;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime createdAt;
  final String? imageUrl;

  UserMealPlan({
    required this.id,
    required this.userId,
    required this.planDate,
    required this.mealType,
    required this.dishDescription,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.createdAt,
    this.imageUrl,
  });

  factory UserMealPlan.fromJson(Map<String, dynamic> json) {
    return UserMealPlan(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      planDate: DateTime.parse(json['plan_date'] as String),
      mealType: json['meal_type'] as int,
      dishDescription: json['dish_description'] as String,
      calories: json['calories'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_date': planDate.toIso8601String(),
      'meal_type': mealType,
      'dish_description': dishDescription,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      if (imageUrl != null) 'image_url': imageUrl,
      // 'created_at' lo gestiona el servidor
    };
  }
}
