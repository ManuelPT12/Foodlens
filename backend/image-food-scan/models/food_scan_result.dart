class FoodScanResult {
  final String name;
  final double calories, protein, fat, carbs;

  FoodScanResult({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  factory FoodScanResult.fromJson(Map<String, dynamic> json) {
    return FoodScanResult(
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'],
      fat: json['fat'],
      carbs: json['carbs'],
    );
  }
}
