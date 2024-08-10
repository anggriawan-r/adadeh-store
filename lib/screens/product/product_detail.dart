import 'package:adadeh_store/blocs/cart/cart_bloc.dart';
import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/notifications/notification_helper.dart';
import 'package:adadeh_store/screens/product/components/product_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProductDetail extends StatefulWidget {
  final String id;

  const ProductDetail({super.key, required this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _isSnackBarVisible = false;

  @override
  Widget build(BuildContext context) {
    final cartState = context.read<CartBloc>().state;

    final productWithCategory =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final product = productWithCategory['product'] as ProductModel;
    final category = productWithCategory['category'] as CategoryModel;

    void showSnackBar(String message) {
      if (_isSnackBarVisible) return;

      setState(() {
        _isSnackBarVisible = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          onVisible: () {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _isSnackBarVisible = false;
              });
            });
          },
        ),
      );
    }

    void addToCart(BuildContext context, CartState cartState) async {
      context.read<CartBloc>().add(AddToCart(widget.id, 1));

      if (cartState is CartLoaded) {
        showSnackBar('Added to cart');
        await NotificationHelper.flutterLocalNotificationsPlugin.show(
          0,
          'Keranjang ditambahkan',
          'Tunggu apa lagi, ayo checkout sekarang!',
          NotificationHelper.notificationDetails,
        );
      } else if (cartState is CartError) {
        showSnackBar('Something went wrong. Please try again.');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: cartState is CartLoading
                    ? null
                    : () => addToCart(context, cartState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    cartState is CartLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Iconsax.shopping_cart),
                    const SizedBox(width: 12),
                    const Text('Add to cart'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInfo(product: product, category: category),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
