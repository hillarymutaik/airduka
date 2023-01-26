/// Author: Hillary Mutai
/// profile: https://github.com/hillarymutaik

class Data {
  final String path;

  final String name;

  final String price;

  final String seller;

  const Data(
      {required this.path,
      required this.name,
      required this.price,
      required this.seller});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        path: json['featured_image']['digital_ocean_url'],
        name: json['title'],
        price: json['price'],
        seller: json['company']['name']);
  }
}
