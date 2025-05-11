class DishAllergen {
  final int dishId;
  final int allergenId;

  DishAllergen({
    required this.dishId,
    required this.allergenId,
  });

  factory DishAllergen.fromJson(Map<String, dynamic> json) {
    return DishAllergen(
      dishId: json['dish_id'] as int,
      allergenId: json['allergen_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish_id': dishId,
      'allergen_id': allergenId,
    };
  }
}
