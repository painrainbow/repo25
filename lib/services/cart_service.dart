import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String description;
  final String price;
  final String size;
  final String imagePath; // Добавляем путь к изображению
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.size,
    required this.imagePath, // Добавляем в конструктор
    this.quantity = 1,
  });
}

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(0, (total, item) {
      final price = double.parse(item.price.replaceAll('\$', ''));
      return total + (price * item.quantity);
    });
  }

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere(
        (cartItem) => cartItem.id == item.id && cartItem.size == item.size);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id, String size) {
    _items.removeWhere((item) => item.id == id && item.size == size);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
