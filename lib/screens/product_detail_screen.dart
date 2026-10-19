import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  String _formatLabel(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;

          return '${word[0].toUpperCase()}'
              '${word.substring(1)}';
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ürün görseli.
            Container(
              height: 280,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            // Ürün adı, kısa açıklaması ve fiyatı.
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  if (product.tagline.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      product.tagline,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],

                  const SizedBox(height: 16),

                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF315CFD),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Ürün açıklaması.
                  Text(
                    'Ürün Açıklaması',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description.trim().isEmpty
                        ? 'Bu ürün için açıklama bulunmuyor.'
                        : product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  // Dinamik teknik özellikler.
                  Text(
                    'Teknik Özellikler',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  if (product.specs.isEmpty)
                    const Text('Bu ürün için teknik özellik bulunmuyor.')
                  else
                    ...product.specs.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                _formatLabel(entry.key),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Text(entry.value?.toString() ?? '-'),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bu aşamada sadece geçici bir buton.
      // Gerçek sepet state'i sonraki aşamada eklenecek.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Sepet işlevi bir sonraki aşamada eklenecek.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Sepete Ekle'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
