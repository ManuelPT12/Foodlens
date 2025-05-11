class UserDiet {
  final int userId;
  final int dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFat;
  final DateTime calculatedAt;

  UserDiet({
    required this.userId,
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.calculatedAt,
  });

  factory UserDiet.fromJson(Map<String, dynamic> json) {
    return UserDiet(
      userId: json['user_id'] as int,
      dailyCalories: json['daily_calories'] as int,
      dailyProtein: (json['daily_protein'] as num).toDouble(),
      dailyCarbs: (json['daily_carbs'] as num).toDouble(),
      dailyFat: (json['daily_fat'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'daily_calories': dailyCalories,
      'daily_protein': dailyProtein,
      'daily_carbs': dailyCarbs,
      'daily_fat': dailyFat,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}
