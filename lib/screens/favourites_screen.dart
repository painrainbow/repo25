import 'package:flutter/material.dart';
import '../theme/text_styles.dart';
import '../widgets/product_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites', style: AppTextStyles.screenTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Favourites will be here'),
      ),
    );
  }
}
