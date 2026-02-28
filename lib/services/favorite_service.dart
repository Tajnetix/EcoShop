import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/favorite_model.dart';

class FavoriteService {
  final supabase = Supabase.instance.client;

  static final List<FavoriteItem> _localFavorites = [];

  // ===============================
  // ADD TO FAVORITE
  // ===============================
  Future<void> addToFavorite(FavoriteItem item) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      final exists = _localFavorites
          .any((fav) => fav.productId == item.productId);

      if (!exists) {
        _localFavorites.add(item);
      }
    } else {
      final existing = await supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .eq('product_id', item.productId)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('favorites').insert({
          'user_id': user.id,
          'product_id': item.productId,
          'name': item.name,
          'price': item.price,
          'image_url': item.imageUrl,
        });
      }
    }
  }

  // ===============================
  // GET FAVORITES
  // ===============================
  Future<List<FavoriteItem>> getFavorites() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return _localFavorites;
    } else {
      final data = await supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => FavoriteItem.fromMap(e))
          .toList();
    }
  }

  // ===============================
  // REMOVE FROM FAVORITE
  // ===============================
  Future<bool> removeFromFavorite(String productId) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      _localFavorites.removeWhere(
          (item) => item.productId == productId);
      return true;
    } else {
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', productId);

      return true;
    }
  }

  // ===============================
  // CHECK IF FAVORITE
  // ===============================
  Future<bool> isFavorite(String productId) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return _localFavorites
          .any((item) => item.productId == productId);
    } else {
      final data = await supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('product_id', productId)
          .maybeSingle();

      return data != null;
    }
  }
}