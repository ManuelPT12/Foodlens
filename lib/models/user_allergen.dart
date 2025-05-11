class UserAllergen {
  final int userId;
  final int allergenId;

  UserAllergen({
    required this.userId,
    required this.allergenId,
  });

  factory UserAllergen.fromJson(Map<String, dynamic> json) {
    return UserAllergen(
      userId: json['user_id'] as int,
      allergenId: json['allergen_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'allergen_id': allergenId,
    };
  }
}
