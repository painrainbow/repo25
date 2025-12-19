import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imagePath;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  title: title,
                  price: price,
                  description: description,
                  imagePath: imagePath, // Передаем путь к изображению
                ),
              ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Real image instead of placeholder
            Container(
              height: 140,
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.productTitle),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.productDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(price, style: AppTextStyles.productPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
