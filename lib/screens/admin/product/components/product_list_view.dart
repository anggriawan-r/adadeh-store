import 'package:adadeh_store/blocs/product/product_bloc.dart';
import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProductListView extends StatelessWidget {
  final AllProductsLoaded state;
  final void Function(BuildContext, ProductModel) onDelete;

  const ProductListView({
    super.key,
    required this.state,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.productsWithCategory.length,
      itemBuilder: (context, index) {
        final productWithCategory = state.productsWithCategory[index];
        final product = productWithCategory['product'] as ProductModel;
        final category = productWithCategory['category'] as CategoryModel;

        return GestureDetector(
          onTap: () {
            context.push(
              '${RouteNames.adminProduct}/${product.id}',
              extra: productWithCategory,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product.imageUrl,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currencyFormatter(product.price),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Stock: ${product.stock.toString()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.isLowStock) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Low Stock!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(
                            '${RouteNames.adminProduct}/${product.id}/edit',
                            extra: productWithCategory,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text('Edit Product'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        onDelete(context, product);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Iconsax.trash,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 0,
      ),
    );
  }
}
