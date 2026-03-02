import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);

  List<CartItem> get cartItems => _items;
  int get totalItems => _items.length;

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addToCart(CartItem item) {
    int index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(item);
    }
    cartCountNotifier.value = _items.length;
  }

  void removeFromCart(CartItem item) {
    _items.removeWhere((e) => e.id == item.id);
    cartCountNotifier.value = _items.length;
  }

  void increaseQty(CartItem item) {
    item.quantity += 1;
    cartCountNotifier.value = _items.length;
  }

  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      removeFromCart(item);
    }
    cartCountNotifier.value = _items.length;
  }

  void clearCart() {
    _items.clear();
    cartCountNotifier.value = 0;
  }
}