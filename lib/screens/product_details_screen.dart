import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../services/cart_service.dart';
import '../screens/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final String imagePath;

  const ProductDetailsScreen({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: AppTextStyles.screenTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Real product image
              Container(
                height: 300,
                width: double.infinity,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),

              // Остальной код остается таким же...
              const SizedBox(height: 20),
              Text(widget.title, style: AppTextStyles.screenTitle),
              const SizedBox(height: 8),
              Text(widget.price,
                  style: AppTextStyles.productPrice.copyWith(fontSize: 18)),
              const SizedBox(height: 20),
              const Divider(color: AppColors.textSecondary, height: 1),
              const SizedBox(height: 20),
              Text('Description',
                  style: AppTextStyles.productTitle.copyWith(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Durable and reliable product with modern design.',
                style: AppTextStyles.productDescription.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Text('Size',
                  style: AppTextStyles.productTitle.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['S', 'M', 'L', 'XL'].map((size) {
                  final isSelected = selectedSize == size;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.buttonTextPrimary
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final newItem = CartItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: widget.title,
                      description: widget.description,
                      price: widget.price.replaceAll('\$', ''),
                      size: selectedSize,
                      imagePath:
                          widget.imagePath, // Добавляем путь к изображению
                    );

                    cartService.addItem(newItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Added to cart: ${widget.title} (Size: $selectedSize)'),
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Add to Cart', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
