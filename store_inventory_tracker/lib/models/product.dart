class Product {
  final String id;
  String name;
  int quantity;
  String category;
  String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.imageUrl,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      quantity: (data['quantity'] ?? 0) is int
          ? data['quantity'] as int
          : int.tryParse(data['quantity'].toString()) ?? 0,
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}
