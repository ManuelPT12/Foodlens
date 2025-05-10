// lib/models/food_scan_result.dart

class FoodScanResult {
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  FoodScanResult({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  /// Construye un FoodScanResult a partir del JSON que devuelve la API
  factory FoodScanResult.fromJson(Map<String, dynamic> json) {
    return FoodScanResult(
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
    );
  }

  /// Convierte este objeto a JSON (útil si necesitas reenviarlo o guardarlo)
  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'fat': fat,
        'carbs': carbs,
      };
}
