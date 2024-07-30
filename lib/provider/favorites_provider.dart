import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class FavoritesProvider with ChangeNotifier {
  final Box _favoritesBox = Hive.box('favoriteStaff');

  List<int> get favoriteContactIds {
    return List<int>.from(_favoritesBox.get('favorites', defaultValue: []));
  }

  void addFavorite(int contactId) {
    final List<int> updatedFavorites =
        List<int>.from(_favoritesBox.get('favorites', defaultValue: []));
    if (!updatedFavorites.contains(contactId)) {
      updatedFavorites.add(contactId);
      _favoritesBox.put('favorites', updatedFavorites);
      notifyListeners();
    }
  }

  void removeFavorite(int contactId) {
    final List<int> updatedFavorites =
        List<int>.from(_favoritesBox.get('favorites', defaultValue: []));
    updatedFavorites.remove(contactId);
    _favoritesBox.put('favorites', updatedFavorites);
    notifyListeners();
  }

  bool isFavorite(int contactId) {
    final List<int> favorites =
        List<int>.from(_favoritesBox.get('favorites', defaultValue: []));
    return favorites.contains(contactId);
  }
}
