class UserRestaurantRating {
  final int userId;
  final int restaurantId;
  final double rating;
  final String review;
  final DateTime ratedAt;

  UserRestaurantRating({
    required this.userId,
    required this.restaurantId,
    required this.rating,
    required this.review,
    required this.ratedAt,
  });

  factory UserRestaurantRating.fromJson(Map<String, dynamic> json) {
    return UserRestaurantRating(
      userId: json['user_id'] as int,
      restaurantId: json['restaurant_id'] as int,
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String,
      ratedAt: DateTime.parse(json['rated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'restaurant_id': restaurantId,
      'rating': rating,
      'review': review,
      // 'rated_at' lo pone el servidor
    };
  }
}
