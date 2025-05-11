class MealType {
  final int id;
  final String name;

  MealType({
    required this.id,
    required this.name,
  });

  factory MealType.fromJson(Map<String, dynamic> json) {
    return MealType(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
