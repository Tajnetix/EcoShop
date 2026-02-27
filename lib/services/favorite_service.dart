import '../models/cart_item.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final List<CartItem> _favorites = [];

  List<CartItem> get favorites => _favorites;

  int get totalItems => _favorites.length;

  void addToFavorite(CartItem item) {
    if (!_favorites.any((e) => e.id == item.id)) {
      _favorites.add(item);
    }
  }

  void removeFromFavorite(String id) {
    _favorites.removeWhere((e) => e.id == id);
  }

  bool isFavorite(String id) {
    return _favorites.any((e) => e.id == id);
  }
}