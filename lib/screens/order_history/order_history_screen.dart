import 'package:adadeh_store/blocs/order/order_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  void _showCancelDialog(
      BuildContext context, String orderId, List<dynamic> products) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Cancel Order'),
          content: const Text('Are you sure want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                context.read<OrderBloc>().add(UpdateOrderStatus(
                      orderId: orderId,
                      status: 'cancelled',
                      products: products,
                    ));

                Navigator.pop(context);
              },
              child: const Text('Cancel Order',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(LoadOrders());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoaded) {
                    if (state.orders.isEmpty) {
                      return const Center(
                        child: Text('No Orders Found.'),
                      );
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];

                        return Container(
                          margin: EdgeInsets.only(
                              bottom:
                                  index != state.orders.length - 1 ? 16 : 0),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateTime.parse(order.orderDate)
                                        .toLocal()
                                        .toString()
                                        .substring(0, 16),
                                  ),
                                  Chip(
                                    visualDensity: VisualDensity.compact,
                                    backgroundColor: order.status == 'cancelled'
                                        ? Colors.redAccent
                                        : Colors.green,
                                    labelPadding: EdgeInsets.zero,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    side: BorderSide.none,
                                    label: Text(
                                      order.status.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: order.products.length,
                                itemBuilder: (context, index) {
                                  final product = order.products[index];

                                  final price = product['price'] as num;
                                  final quantity = product['quantity'] as num;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '$quantity Item(s) x ${currencyFormatter(price.toInt())}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        currencyFormatter(
                                            order.totalAmount.toInt()),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  order.status != 'cancelled' &&
                                          order.status != 'success'
                                      ? Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                _showCancelDialog(
                                                  context,
                                                  order.id,
                                                  order.products,
                                                );
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (order.paymentMethod ==
                                                          'gopay' ||
                                                      order.paymentMethod ==
                                                          'ovo') {
                                                    context.push(
                                                        RouteNames
                                                            .paymentWallet,
                                                        extra: {
                                                          'orderId': order.id,
                                                          'totalAmount':
                                                              order.totalAmount,
                                                          'paymentMethod': order
                                                              .paymentMethod
                                                        });
                                                  } else {
                                                    context.push(
                                                        RouteNames.paymentDebit,
                                                        extra: {
                                                          'orderId': order.id,
                                                          'totalAmount':
                                                              order.totalAmount,
                                                          'paymentMethod': order
                                                              .paymentMethod
                                                        });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.black,
                                                ),
                                                child: const Text(
                                                  'Pay Now',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is OrderLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is OrderFailure) {
                    return Center(
                      child: Text(state.error),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
