import '../models/cart_item.dart';

class CartService {
  /// 🔹 Singleton Instance
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  /// 🔹 Private Cart List
  final List<CartItem> _items = [];

  /// 🔹 Public Getter (Recommended)
  List<CartItem> get items => _items;

  /// (Optional) If you want to use cartItems name also
  List<CartItem> get cartItems => _items;

  /// 🛒 ADD TO CART
  void addToCart(CartItem item) {
    final index = _items.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
  }

  /// ❌ REMOVE ITEM
  void removeFromCart(CartItem item) {
    _items.removeWhere((e) => e.id == item.id);
  }

  /// ➕ INCREASE QUANTITY
  void increaseQty(CartItem item) {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _items[index].quantity++;
    }
  }

  /// ➖ DECREASE QUANTITY
  void decreaseQty(CartItem item) {
    final index = _items.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  /// 💰 TOTAL PRICE
  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  /// 🔢 TOTAL ITEM COUNT
  int get totalItems {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  /// 🧹 CLEAR CART
  void clearCart() {
    _items.clear();
  }
}