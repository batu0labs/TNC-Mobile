import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> loadProducts() async {
    final jsonString = await rootBundle.loadString('assets/data/products.json');

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    final items = decoded['data'] as List<dynamic>;

    return items.map((item) {
      return Product.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }
}
