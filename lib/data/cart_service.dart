import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});
}

class CartService extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  // Sepetteki ürünleri dışarıya salt okunur liste olarak sunar.
  List<CartItem> get items => List<CartItem>.unmodifiable(_items.values);

  // Sepetteki toplam ürün adedi.
  int get totalItems {
    return _items.values.fold(0, (total, item) => total + item.quantity);
  }

  bool get isEmpty => _items.isEmpty;

  // Ürün fiyatlarını toplamak için sayısal değere dönüştürür.
  double _parsePrice(String rawPrice) {
    final normalized = rawPrice
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(normalized) ?? 0;
  }

  // Sepetin ara toplamı.
  double get totalPrice {
    return _items.values.fold(0.0, (total, item) {
      return total + (_parsePrice(item.product.price) * item.quantity);
    });
  }

  // İlk üründen para birimini alır.
  // Bu örnek, katalogdaki ürünlerin aynı para biriminde
  // fiyatlandırıldığını varsayar.
  String get currency {
    if (_items.isEmpty) return 'USD';
    return _items.values.first.product.currency;
  }

  // Ürün yoksa ekler, varsa miktarını bir artırır.
  void addProduct(Product product) {
    final existingItem = _items[product.id];

    _items[product.id] = CartItem(
      product: product,
      quantity: (existingItem?.quantity ?? 0) + 1,
    );

    notifyListeners();
  }

  // Miktarı bir azaltır. Miktar 1 ise ürünü kaldırır.
  void decreaseQuantity(int productId) {
    final existingItem = _items[productId];

    if (existingItem == null) return;

    if (existingItem.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId] = CartItem(
        product: existingItem.product,
        quantity: existingItem.quantity - 1,
      );
    }

    notifyListeners();
  }

  // Ürünü miktarından bağımsız olarak tamamen kaldırır.
  void removeProduct(int productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  // Sepeti tamamen boşaltır.
  void clear() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
  }
}
