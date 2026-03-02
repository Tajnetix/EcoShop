import '../models/order_model.dart';

class OrderService {
  static final OrderService _instance =
      OrderService._internal();

  factory OrderService() => _instance;

  OrderService._internal();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(OrderModel order) {
    _orders.add(order);
  }

  double get totalSpent {
    double total = 0;
    for (var order in _orders) {
      total += order.totalAmount;
    }
    return total;
  }

  int get totalOrders => _orders.length;

  int get totalProductsBought {
    int count = 0;
    for (var order in _orders) {
      for (var item in order.items) {
        count += item.quantity;
      }
    }
    return count;
  }
}