import 'package:flutter/material.dart';
import '../theme/text_styles.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data with image paths
    final products = [
      {
        'title': 'Classic T-Shirt',
        'description': 'Comfortable cotton t-shirt',
        'price': '\$17.00',
        'image': 'assets/images/product1.png',
      },
      {
        'title': 'Summer Dress',
        'description': 'Light and beautiful dress',
        'price': '\$25.00',
        'image': 'assets/images/product2.png',
      },
      {
        'title': 'Denim Jacket',
        'description': 'Stylish denim jacket',
        'price': '\$45.00',
        'image': 'assets/images/product3.png',
      },
      {
        'title': 'Sports Shoes',
        'description': 'Comfortable running shoes',
        'price': '\$60.00',
        'image': 'assets/images/product4.png',
      },
      {
        'title': 'Winter Sweater',
        'description': 'Warm wool sweater',
        'price': '\$35.00',
        'image': 'assets/images/product5.png',
      },
      {
        'title': 'Elegant Skirt',
        'description': 'Perfect for special occasions',
        'price': '\$28.00',
        'image': 'assets/images/product6.png',
      },
      // Добавьте остальные 3 товара по аналогии
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Clothing', style: AppTextStyles.screenTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              title: product['title']!,
              description: product['description']!,
              price: product['price']!,
              imagePath: product['image']!,
            );
          },
        ),
      ),
    );
  }
}
