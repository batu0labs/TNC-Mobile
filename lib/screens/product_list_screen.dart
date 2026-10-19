import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const String routeName = '/products';

  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;

  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void initState() {
    super.initState();

    // JSON dosyasını yükleme işlemi bir kez başlatılır.
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = ProductRepository().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Türkçe karakterler için basit arama normalizasyonu.
  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll('\u0307', '');
  }

  void _openProduct(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      body: SafeArea(
        child: Column(
          children: [
            // Arama alanı.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ürün ara...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();

                            setState(() {
                              _query = '';
                            });
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // JSON yükleme ve listeleme alanı.
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  // 1. Yükleme devam ediyor.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Yükleme başarısız.
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Ürünler yüklenemedi.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _loadProducts();
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tekrar dene'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 3. Veri alınmış mı?
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Ürün verisi bulunamadı.'));
                  }

                  final products = snapshot.data!;

                  // 4. Arama metnine göre filtrele.
                  final filteredProducts = products.where((product) {
                    final searchableText =
                        '${product.name} '
                        '${product.tagline} '
                        '${product.description}';

                    return _normalize(searchableText)
                        .contains(_normalize(_query.trim()));
                  }).toList();

                  // 5. Eşleşen ürün yoksa.
                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _query.trim().isEmpty
                                  ? 'Gösterilecek ürün bulunamadı.'
                                  : 'Aramanızla eşleşen ürün bulunamadı.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 6. Ürünleri iki sütunlu grid ile göster.
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          _openProduct(product);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
