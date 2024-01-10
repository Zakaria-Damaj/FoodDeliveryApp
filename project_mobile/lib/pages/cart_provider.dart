import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  bool isItemInCart(Map<String, dynamic> item) {
    print(item);
    return _cartItems.any((cartItem) => cartItem['item_id'] == item['item_id']);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void addToCart(Map<String, dynamic> item) {
    if (isItemInCart(item)) {
      increaseQuantity(item);
    } else {
      item['quantity'] = 1;
      _cartItems.add(item);
      notifyListeners();
    }
  }

  void increaseQuantity(Map<String, dynamic> item) {
    int index = _cartItems
        .indexWhere((cartItem) => cartItem['item_id'] == item['item_id']);
    if (index != -1) {
      _cartItems[index]['quantity'] = (_cartItems[index]['quantity'] ?? 1) + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(Map<String, dynamic> item) {
    int index = _cartItems
        .indexWhere((cartItem) => cartItem['item_id'] == item['item_id']);
    if (index != -1) {
      int currentQuantity = _cartItems[index]['quantity'] ?? 1;
      if (currentQuantity > 1) {
        _cartItems[index]['quantity'] = currentQuantity - 1;
        notifyListeners();
      }
    }
  }

  void removeFromCart(Map<String, dynamic> item) {
    _cartItems
        .removeWhere((cartItem) => cartItem['item_id'] == item['item_id']);
    notifyListeners();
  }

  int getTotalItems() {
    int totalItems = 0;
    for (var item in _cartItems) {
      totalItems += (item['quantity'] ?? 0) as int;
    }
    return totalItems;
  }

  double getTotalPrice() {
    double totalPrice = 0;

    for (var item in _cartItems) {
      // Convert the item price and quantity to numeric types
      double itemPrice = double.tryParse(item['item_price'] ?? '0') ?? 0;
      int quantity = (item['quantity'] ?? 0).toInt();

      totalPrice += itemPrice * quantity;
    }

    return totalPrice;
  }
}
