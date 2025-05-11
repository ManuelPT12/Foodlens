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
  final String dietType;
  final String email;
  final String password;
  final DateTime createdAt;
  final String activityLevel;
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
    required this.dietType,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.activityLevel,
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
      dietType: json['diet_type'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      activityLevel: json['activity_level'] as String,
      isDiabetic: json['is_diabetic'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate.toIso8601String(),
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'goal': goal,
      'diet_type': dietType,
      'email': email,
      'password': password,
      // 'created_at' lo genera el servidor
      'activity_level': activityLevel,
      'is_diabetic': isDiabetic,
    };
  }
}
