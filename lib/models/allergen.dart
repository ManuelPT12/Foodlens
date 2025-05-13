class Allergen {
  final int id;
  final String name;
  final String? iconUrl;
  final String? description;

  Allergen({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      id: json['id'] as int,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
      'description': description,
    };
  }
}
