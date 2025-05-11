class UserFavoriteMealType {
  final int userId;
  final int mealTypeId;

  UserFavoriteMealType({
    required this.userId,
    required this.mealTypeId,
  });

  factory UserFavoriteMealType.fromJson(Map<String, dynamic> json) {
    return UserFavoriteMealType(
      userId: json['user_id'] as int,
      mealTypeId: json['meal_type_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'meal_type_id': mealTypeId,
    };
  }
}
