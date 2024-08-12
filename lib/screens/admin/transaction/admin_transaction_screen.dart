import 'package:adadeh_store/blocs/transaction/transaction_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/admin/transaction/components/search_transaction_bar.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminTransactionScreen extends StatelessWidget {
  const AdminTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          'Transaction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SearchTransactionBar(),
              const SizedBox(height: 8),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoaded) {
                    if (state.transactions.isEmpty) {
                      return const Center(
                        child: Text('No transaction Found.'),
                      );
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final order = state.transactions[index];

                        return Container(
                          margin: EdgeInsets.only(
                              bottom: index != state.transactions.length - 1
                                  ? 8
                                  : 0),
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
                                  ElevatedButton(
                                    onPressed: () {
                                      context.push(
                                        '${RouteNames.adminTransaction}/${RouteNames.paymentStatus}',
                                        extra: order,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    child: const Text('See Details'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is TransactionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TransactionError) {
                    return Center(
                      child: Text(state.message),
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
