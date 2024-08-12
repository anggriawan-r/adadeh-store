import 'package:adadeh_store/blocs/cart/cart_bloc.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isMasterChecked = false;

  @override
  Widget build(BuildContext context) {
    void toggleMasterCheckbox(bool? value) {
      setState(() {
        isMasterChecked = value ?? false;
        context.read<CartBloc>().add(SelectAllCarts(isMasterChecked));
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            final productsWithCategory = state.productsWithCategory;

            final productsChecked = productsWithCategory
                .where((item) => item['isChecked'])
                .toList();

            final hasCheckedItems = productsWithCategory
                .where((item) => item['isChecked'])
                .isNotEmpty;

            int totalPrice = productsWithCategory
                .where((item) => item['isChecked'])
                .fold<int>(
              0,
              (total, item) {
                final product = item['product'] as ProductModel;
                return total + item['quantity'] * product.price as int;
              },
            );

            if (productsWithCategory.isEmpty) {
              isMasterChecked = false;
            } else {
              isMasterChecked =
                  productsWithCategory.every((item) => item['isChecked']);
            }

            final orderDetail = {
              'products': productsChecked,
              'totalPrice': totalPrice,
            };

            return Container(
              height: 80,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, -1),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: isMasterChecked,
                      onChanged: (value) => toggleMasterCheckbox(value),
                      activeColor: Colors.black,
                    ),
                    const SizedBox(width: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Total'),
                            Text(
                              currencyFormatter(totalPrice.toInt()),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                              ),
                              onPressed: hasCheckedItems
                                  ? () {
                                      context.push(
                                        '${RouteNames.cart}/${RouteNames.order}',
                                        extra: orderDetail,
                                      );
                                    }
                                  : null,
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                  color: hasCheckedItems
                                      ? Colors.black
                                      : Colors.grey.shade400,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(height: 80, color: Colors.white);
          }
        },
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartEmpty) {
            return const Center(child: Text('Cart is empty. Let\'s add some!'));
          } else if (state is CartLoaded) {
            final productsWithCategory = state.productsWithCategory;

            if (productsWithCategory.isEmpty) {
              return const Center(
                  child: Text('Cart is empty. Let\'s add some!'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productsWithCategory.length,
                    itemBuilder: (context, index) {
                      final item = productsWithCategory[index];
                      final product = item['product'] as ProductModel;
                      final quantity = item['quantity'] as int;
                      final isChecked = item['isChecked'] as bool;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 8,
                          right: 8,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    context.read<CartBloc>().add(
                                        UpdateCartItem(product.id, value!));
                                  },
                                  activeColor: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item['category'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        currencyFormatter(product.price),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CartBloc>()
                                        .add(RemoveFromCart(product.id));
                                  },
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CartBloc>()
                                        .add(DecrementQuantity(product.id));
                                  },
                                  icon: const Icon(Icons.remove),
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CartBloc>()
                                        .add(IncrementQuantity(product.id));
                                  },
                                  icon: const Icon(Icons.add),
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
