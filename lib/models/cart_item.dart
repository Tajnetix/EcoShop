class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  int ecoPoints;
  double co2Saved;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.ecoPoints = 0,
    this.co2Saved = 0.0,
  });
}