class OrderModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String status;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.status,
    required this.date,
  });
}