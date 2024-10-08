import 'package:adadeh_store/blocs/product/product_bloc.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/admin/product/components/product_list_view.dart';
import 'package:adadeh_store/screens/admin/product/components/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminProductScreen extends StatelessWidget {
  const AdminProductScreen({super.key});

  void _alertLowStock(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low Stock'),
        content: const Text('There are products with low stock.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(DeleteProduct(productId: product.id));

              return Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(LoadAllProductsWithCategory());

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is AllProductsLoaded) {
          final isLowStock = state.productsWithCategory
              .where((productWithCategory) =>
                  productWithCategory['product'] is ProductModel &&
                  (productWithCategory['product'] as ProductModel).stock <= 10)
              .isNotEmpty;

          if (isLowStock) {
            _alertLowStock(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.push(RouteNames.addProduct);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Add Product'),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Product',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 128.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
                } else if (state is AllProductsLoaded) {
                  return Column(
                    children: [
                      const SearchAppBar(),
                      state.productsWithCategory.isEmpty
                          ? const Center(
                              child: Text('No Products Found.'),
                            )
                          : ProductListView(
                              state: state,
                              onDelete: _showDialog,
                            ),
                    ],
                  );
                } else if (state is ProductError) {
                  return Center(child: Text(state.error));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
