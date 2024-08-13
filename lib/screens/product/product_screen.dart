import 'package:adadeh_store/blocs/product/product_bloc.dart';
import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/product/components/product_grid_fake.dart';
import 'package:adadeh_store/screens/product/components/search_appbar.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SearchAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Column(
              children: [
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Skeletonizer(
                        enabled: true,
                        child: ProductGridFake(),
                      );
                    } else if (state is AllProductsLoaded) {
                      if (state.productsWithCategory.isEmpty) {
                        return const Center(
                          child: Text('No Products Found.'),
                        );
                      }

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
  final AllProductsLoaded state;

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
      itemCount: state.productsWithCategory.length,
      itemBuilder: (context, index) {
        final productWithCategory = state.productsWithCategory[index];
        final product = productWithCategory['product'] as ProductModel;
        final category = productWithCategory['category'] as CategoryModel;

        return GestureDetector(
          onTap: () {
            context.push(
              '${RouteNames.product}/${product.id}',
              extra: productWithCategory,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 40,
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
