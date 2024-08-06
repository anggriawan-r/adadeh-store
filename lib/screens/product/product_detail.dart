import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProductDetail extends StatelessWidget {
  final String id;

  const ProductDetail({super.key, required this.id});

  static const Map<String, dynamic> product = {
    "product": {
      "id": "1",
      "name": "SANDAL MEHANA",
      "description":
          "Dengan nuansa futuristik dan desain yang stylish, sandal adidas ini dapat diandalkan untuk hari yang cerah. Upper breathable terasa fleksibel di kakimu, sehingga kamu dapat bergerak dengan bebas. Penutup gesper yang dapat disesuaikan memberikan fit yang pas.",
      "imageUrl":
          "https://www.adidas.co.id/media/catalog/product/i/g/ig3537_2_footwear_photography_side20lateral20view_grey.jpg",
      "price": 1300000,
      "stock": 100,
    },
    "category": {"name": "Lifestyle"},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(RouteNames.cart);
            },
            icon: const Badge(
              label: Text('2'),
              child: Icon(Iconsax.shopping_cart),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(
            product['product']['imageUrl'],
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductInfo(product: product),
                  const Spacer(),
                  const Divider(
                    height: 32,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.shopping_cart),
                          SizedBox(width: 12),
                          Text('Add to cart'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['category']['name'],
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          product['product']['name'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Stock: ${product['product']['stock'].toString()} units left',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          product['product']['description'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          currencyFormatter(product['product']['price']),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
