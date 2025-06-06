import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String baseUrl =
      'http://192.168.1.141:8000'; // Cambiar si uso físico/Wi-Fi

  Future<int> loginUser({
    required String email,
    required String password,
  }) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data['user_id'] as int;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<int> registerUser({
    required String firstName,
    required String lastName,
    required String birthDate,
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String goal,
    required String dietType,
    required bool isDiabetic,
    required String activityLevel,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final body = {
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'goal': goal,
      'diet_type': dietType,
      'is_diabetic': isDiabetic,
      'activity_level': activityLevel,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('STATUS: \${response.statusCode}');
      print('BODY: \${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['id'] as int;
      } else {
        throw Exception('Error al registrar usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR durante la petición: \$e');
      return 0;
    }
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar usuarios: ${response.statusCode}');
    }
  }

  Future<User> fetchUserById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // print(response.body);
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar usuario $id: ${response.statusCode}');
    }
  }

  Future<User> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? goal,
    String? dietType,
    String? email,
    String? password,
    String? activityLevel,
    bool? isDiabetic,
  }) async {
    final Map<String, dynamic> body = {};
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (birthDate != null) body['birth_date'] = birthDate.toIso8601String();
    if (weight != null) body['weight'] = weight;
    if (height != null) body['height'] = height;
    if (age != null) body['age'] = age;
    if (gender != null) body['gender'] = gender;
    if (goal != null) body['goal'] = goal;
    if (dietType != null) body['diet_type'] = dietType;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;
    if (activityLevel != null)
      body['activity_level'] = activityLevel.toLowerCase();
    if (isDiabetic != null) body['is_diabetic'] = isDiabetic;

    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar usuario: ${response.statusCode}');
    }
  }

  Future<List<Allergen>> fetchAllergens() async {
    final response = await http.get(
      Uri.parse('$baseUrl/allergens/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (jsonItem) => Allergen.fromJson(jsonItem as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Error al cargar los alergénicos: ${response.statusCode}',
      );
    }
  }

  Future<Allergen> createAllergen({
    required String name,
    required String iconUrl,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/allergens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'icon_url': iconUrl,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return Allergen.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear el alergénico: ${response.statusCode}');
    }
  }

  Future<List<UserAllergen>> fetchUserAllergens() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-allergens'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => UserAllergen.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar user_allergens: ${response.statusCode}');
    }
  }

  Future<UserAllergen> registerUserAllergen({
    required int userId,
    required int allergenId,
  }) async {
    final body = {'user_id': userId, 'allergen_id': allergenId};

    final response = await http.post(
      Uri.parse('$baseUrl/user-allergens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return UserAllergen.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear user_allergen: ${response.statusCode}');
    }
  }

  Future<List<Dish>> fetchDishes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dishes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Dish.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar los platos: ${response.statusCode}');
    }
  }

  Future<Dish> createDish({
    required int menuId,
    required String name,
    required String description,
    required double price,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dishes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'menu_id': menuId,
        'name': name,
        'description': description,
        'price': price,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      }),
    );

    if (response.statusCode == 201) {
      return Dish.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear el plato: ${response.statusCode}');
    }
  }

  Future<List<DishAllergen>> fetchDishAllergens() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dish-allergens-registered'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => DishAllergen.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Error al cargar dish_allergens_registered: ${response.statusCode}',
      );
    }
  }

  Future<DishAllergen> registerDishAllergen({
    required int dishId,
    required int allergenId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dish-allergens-registered'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'dish_id': dishId, 'allergen_id': allergenId}),
    );

    if (response.statusCode == 201) {
      return DishAllergen.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al registrar el alergénico en el plato: ${response.statusCode}',
      );
    }
  }

  Future<List<MealLog>> fetchMealLogs({int? userId}) async {
    // Construimos la URI; si userId != null, lo añadimos como query param
    final uri = Uri.parse('$baseUrl/meal-logs/').replace(
      queryParameters: userId != null ? {'user_id': userId.toString()} : null,
    );

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => MealLog.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar meal_log: ${response.statusCode}');
    }
  }

  Future<List<MealLog>> fetchMealLogsByDate({
    required int userId,
    required DateTime date,
  }) async {
    // 1) Trae todos los logs de ese usuario
    final all = await fetchMealLogs(
      userId: userId,
    ); // o if fetchMealLogs acepta userId: fetchMealLogs(userId)
    // 2) Filtra sólo los que coinciden con year/month/day
    return all.where((log) {
      final d = log.mealDate.toLocal();
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  Future<MealLog> createMealLog({
    required int userId,
    required DateTime mealDate,
    required String mealType,
    required String dishName,
    required String description,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    String? imageUrl,
  }) async {
    final body = {
      'user_id': userId,
      'meal_date': mealDate.toIso8601String(),
      'meal_type': mealType,
      'dish_name': dishName,
      'description': description,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      if (imageUrl != null) 'image_url': imageUrl,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/meal-logs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      return MealLog.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear meal_log: ${response.statusCode}');
    }
  }

  Future<List<Menu>> fetchMenus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/menus'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Menu.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar menús: ${response.statusCode}');
    }
  }

  Future<Menu> createMenu({
    required int restaurantId,
    required String name,
    required String imageUrl,
    required DateTime lastUpdated,
  }) async {
    final body = {
      'restaurant_id': restaurantId,
      'name': name,
      'image_url': imageUrl,
      'last_updated': lastUpdated.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/menus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return Menu.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear menú: ${response.statusCode}');
    }
  }

  Future<List<MenuDish>> fetchMenuDishes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/menu-dishes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => MenuDish.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar menu_dishes: ${response.statusCode}');
    }
  }

  Future<MenuDish> createMenuDish({
    required int restaurantMenuId,
    required String name,
    required String description,
    required double price,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    final body = {
      'restaurant_menu_id': restaurantMenuId,
      'name': name,
      'description': description,
      'price': price,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/menu-dishes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return MenuDish.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear menu_dish: ${response.statusCode}');
    }
  }

  Future<List<RestaurantMenu>> fetchRestaurantMenus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurant-menus'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => RestaurantMenu.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Error al cargar restaurant_menus: ${response.statusCode}',
      );
    }
  }

  Future<RestaurantMenu> createRestaurantMenu({
    required int userId,
    required String restaurantName,
    required String location,
    required String imageUrl,
    required DateTime scannedAt,
  }) async {
    final body = {
      'user_id': userId,
      'restaurant_name': restaurantName,
      'location': location,
      'image_url': imageUrl,
      'scanned_at': scannedAt.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/restaurant-menus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return RestaurantMenu.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear restaurant_menu: ${response.statusCode}');
    }
  }

  Future<List<RestaurantTypeLink>> fetchRestaurantTypeLinks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurant-type-links'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (json) => RestaurantTypeLink.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Error al cargar restaurant_type_links: ${response.statusCode}',
      );
    }
  }

  Future<RestaurantTypeLink> registerRestaurantTypeLink({
    required int restaurantId,
    required int typeId,
  }) async {
    final body = {'restaurant_id': restaurantId, 'type_id': typeId};

    final response = await http.post(
      Uri.parse('$baseUrl/restaurant-type-links'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return RestaurantTypeLink.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al crear restaurant_type_link: ${response.statusCode}',
      );
    }
  }

  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurants'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar restaurantes: ${response.statusCode}');
    }
  }

  Future<Restaurant> createRestaurant({
    required String name,
    required String address,
    required String phone,
    required String website,
  }) async {
    final body = {
      'name': name,
      'address': address,
      'phone': phone,
      'website': website,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/restaurants'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return Restaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear restaurante: ${response.statusCode}');
    }
  }

  Future<UserDiet> fetchUserDiet({required int userId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-diets/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserDiet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar user_diet: ${response.statusCode}');
    }
  }

  Future<UserDiet> upsertUserDiet({
    required int userId,
    required int dailyCalories,
    required double dailyProtein,
    required double dailyCarbs,
    required double dailyFat,
  }) async {
    final body = {
      'user_id': userId,
      'daily_calories': dailyCalories,
      'daily_protein': dailyProtein,
      'daily_carbs': dailyCarbs,
      'daily_fat': dailyFat,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/user-diets'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserDiet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al upsert user_diet: ${response.statusCode}');
    }
  }

  Future<List<UserFavoriteMealType>> fetchUserFavoriteMealTypes({
    required int userId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-favorite-meal-types?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (json) =>
                UserFavoriteMealType.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Error al cargar user_favorite_meal_types: ${response.statusCode}',
      );
    }
  }

  Future<UserFavoriteMealType> registerUserFavoriteMealType({
    required int userId,
    required int mealTypeId,
  }) async {
    final body = {'user_id': userId, 'meal_type_id': mealTypeId};

    final response = await http.post(
      Uri.parse('$baseUrl/user-favorite-meal-types'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return UserFavoriteMealType.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al crear user_favorite_meal_type: ${response.statusCode}',
      );
    }
  }

  Future<List<UserMealPlan>> fetchUserMealPlans({required int userId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-meal-plan?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => UserMealPlan.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar user_meal_plan: ${response.statusCode}');
    }
  }

  Future<UserMealPlan> createUserMealPlan({
    required int userId,
    required DateTime planDate,
    required String mealType,
    required String dishDescription,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    String? imageUrl,
  }) async {
    final body = {
      'user_id': userId,
      'plan_date': planDate.toIso8601String(),
      'meal_type': mealType,
      'dish_description': dishDescription,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      if (imageUrl != null) 'image_url': imageUrl,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/user-meal-plan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return UserMealPlan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear user_meal_plan: ${response.statusCode}');
    }
  }

  Future<List<UserRestaurantRating>> fetchUserRestaurantRatings({
    required int userId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-restaurant-ratings?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (json) =>
                UserRestaurantRating.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Error al cargar user_restaurant_ratings: ${response.statusCode}',
      );
    }
  }

  Future<UserRestaurantRating> registerUserRestaurantRating({
    required int userId,
    required int restaurantId,
    required double rating,
    required String review,
  }) async {
    final body = {
      'user_id': userId,
      'restaurant_id': restaurantId,
      'rating': rating,
      'review': review,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/user-restaurant-ratings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return UserRestaurantRating.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al crear user_restaurant_rating: ${response.statusCode}',
      );
    }
  }
}