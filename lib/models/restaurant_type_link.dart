class RestaurantTypeLink {
  final int restaurantId;
  final int typeId;

  RestaurantTypeLink({
    required this.restaurantId,
    required this.typeId,
  });

  factory RestaurantTypeLink.fromJson(Map<String, dynamic> json) {
    return RestaurantTypeLink(
      restaurantId: json['restaurant_id'] as int,
      typeId: json['type_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'type_id': typeId,
    };
  }
}
