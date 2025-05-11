class Restaurant {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String website;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.website,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'website': website,
    };
  }
}
