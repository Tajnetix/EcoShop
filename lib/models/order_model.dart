class OrderModel {
  final String id;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final double totalAmount;
  final DateTime date;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.totalAmount,
    required this.date,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}