class FavoriteItem {
  final String id; // unique ID
  final String productId;
  final String name;
  final double price;
  final String imageUrl;

  FavoriteItem({
    String? id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'].toString(), // Supabase UUID converted to String
      productId: map['product_id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'],
    );
  }
}