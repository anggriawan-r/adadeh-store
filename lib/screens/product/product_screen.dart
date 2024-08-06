import 'package:adadeh_store/blocs/product/product_bloc.dart';
import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/product/components/product_grid_fake.dart';
import 'package:adadeh_store/screens/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Skeletonizer(
                        enabled: true,
                        child: ProductGridFake(),
                      );
                    } else if (state is ProductLoaded) {
                      return ProductGrid(state: state);
                    } else if (state is ProductError) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final ProductLoaded state;

  const ProductGrid({super.key, required this.state});

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
      itemCount: state.productsWithCategories.length,
      itemBuilder: (context, index) {
        final productWithCategory = state.productsWithCategories[index];
        final product = productWithCategory['product'] as ProductModel;
        final category = productWithCategory['category'] as CategoryModel;

        return GestureDetector(
          onTap: () {
            context.push(
              '${RouteNames.product}/${product.id}',
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
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
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currencyFormatter(product.price),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
