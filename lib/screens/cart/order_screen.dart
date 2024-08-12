import 'package:adadeh_store/blocs/order/order_bloc.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:adadeh_store/data/repositories/profile_repository.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? _selectedPaymentType;
  int shippingCost = 20000;
  int adminFee = 1000;

  @override
  Widget build(BuildContext context) {
    final productsChecked =
        GoRouterState.of(context).extra as Map<String, dynamic>;

    final products = productsChecked['products'] as List<Map<String, dynamic>>;
    final int totalPrice = productsChecked['totalPrice'];
    final int totalAmount = totalPrice + shippingCost + adminFee;

    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSubmitted) {
          if (_selectedPaymentType == 'gopay' ||
              _selectedPaymentType == 'ovo') {
            context.pushReplacement(
              RouteNames.paymentWallet,
              extra: state.order,
            );
          } else {
            context.pushReplacement(
              RouteNames.paymentDebit,
              extra: state.order,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade100,
            title: const Text(
              'Order',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  blurRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: _selectedPaymentType != null
                    ? () {
                        context.read<OrderBloc>().add(
                              SubmitOrder(
                                adminFee: adminFee,
                                shippingCost: shippingCost,
                                paymentMethod: _selectedPaymentType!,
                                products: products,
                                totalPrice: totalPrice,
                                userId: FirebaseAuth.instance.currentUser!.uid,
                              ),
                            );
                      }
                    : null,
                child: const Text(
                  'Order Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 90),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                        future: ProfileRepository().getUserProfile(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Iconsax.location),
                                    const SizedBox(width: 8),
                                    Text(snapshot.data!.address),
                                  ],
                                ),
                              ],
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading...');
                          } else {
                            return const Text('Error');
                          }
                        }),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: productsChecked['products'].length,
                    itemBuilder: (context, index) {
                      final productModel =
                          products[index]['product'] as ProductModel;
                      final String category = products[index]['category'];
                      final int quantity = products[index]['quantity'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                productModel.imageUrl,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productModel.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800),
                                  ),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    '$quantity x ${currencyFormatter(productModel.price)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Total Price'),
                            const Spacer(),
                            Text(
                              currencyFormatter(totalPrice),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Shipping cost'),
                            const Spacer(),
                            Text(
                              currencyFormatter(shippingCost),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Admin Fee'),
                            const Spacer(),
                            Text(
                              currencyFormatter(adminFee),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text('Total Amount'),
                            const Spacer(),
                            Text(
                              currencyFormatter(totalAmount),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment method',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Iconsax.card),
                                SizedBox(width: 8),
                                Text('Debit'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            RadioListTile<String>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/BCA.svg',
                                    semanticsLabel: 'BCA Logo',
                                    height: 20,
                                  ),
                                ],
                              ),
                              value: 'bca',
                              groupValue: _selectedPaymentType,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/BRI.svg',
                                    semanticsLabel: 'BRI Logo',
                                    height: 20,
                                  ),
                                ],
                              ),
                              value: 'bri',
                              groupValue: _selectedPaymentType,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/mandiri.svg',
                                    semanticsLabel: 'Mandiri Logo',
                                    height: 24,
                                  ),
                                ],
                              ),
                              value: 'mandiri',
                              groupValue: _selectedPaymentType,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Iconsax.wallet),
                                SizedBox(width: 8),
                                Text('E-Wallet'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            RadioListTile<String>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/OVO.svg',
                                    semanticsLabel: 'OVO Logo',
                                    height: 16,
                                  ),
                                ],
                              ),
                              value: 'ovo',
                              groupValue: _selectedPaymentType,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/gopay.svg',
                                    semanticsLabel: 'Gopay Logo',
                                    height: 16,
                                  ),
                                ],
                              ),
                              value: 'gopay',
                              groupValue: _selectedPaymentType,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
