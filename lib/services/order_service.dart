import '../models/order_model.dart';

class OrderService {
  static final List<OrderModel> _orders = [];
  static bool hasNewOrder = false;

  List<OrderModel> get orders => _orders;

  void addOrder(OrderModel order) {
    _orders.insert(0, order); // newest first
    hasNewOrder = true;
  }

  void clearNotification() {
    hasNewOrder = false;
  }
}