import 'package:adadeh_store/screens/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ProductGridFake extends StatelessWidget {
  const ProductGridFake({super.key});

  static final List<Map<String, dynamic>> _products = [
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
    {
      "product": {
        "name": 'Product 1',
        "price": 100,
        "description": 'Product 1 description',
        "imageUrl": 'https://picsum.photos/200/300',
      },
      "category": {
        "name": "Product 1",
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 270,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: double.infinity,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _products[index]['category']['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _products[index]['product']['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currencyFormatter(_products[index]['product']['price']),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
