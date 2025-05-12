class User {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String goal;
  final String email;
  // Estos campos pueden no venir: hazlos opcionales
  final String? dietType;
  final String? activityLevel;
  // Normalmente no devuelves la password al cliente, así que lo quitamos:
  // final String password;
  final DateTime createdAt;
  final bool isDiabetic;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.goal,
    required this.email,
    this.dietType,
    this.activityLevel,
    required this.createdAt,
    required this.isDiabetic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      age: json['age'] as int,
      gender: json['gender'] as String,
      goal: json['goal'] as String,
      email: json['email'] as String,
      // Usa cast nullable; si no existe la clave, será null
      dietType: json['diet_type'] as String?,
      activityLevel: json['activity_level'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isDiabetic: json['is_diabetic'] as bool,
    );
  }
}
