import 'package:adadeh_store/blocs/order/order_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  final List<Map<String, dynamic>> buttons = [
    {
      'icon': Iconsax.box,
      'label': 'Product',
      'destination': RouteNames.adminProduct,
    },
    {
      'icon': Iconsax.user,
      'label': 'Customer',
      'destination': RouteNames.adminCustomer,
    },
    {
      'icon': Iconsax.transaction_minus,
      'label': 'Transaction',
      'destination': RouteNames.adminTransaction,
    },
    {
      'icon': Iconsax.category_2,
      'label': 'Category',
      'destination': RouteNames.adminCategory,
    },
  ];

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(LoadOrders());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTime.now().toLocal().toString().split(' ')[0],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'Welcome, Admin!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoaded) {
                          final totalRevenue = state.orders
                              .where((order) => order.status == 'success')
                              .fold(0.0,
                                  (total, order) => total + order.totalAmount);

                          return Text(
                            currencyFormatter(totalRevenue.toInt()),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          );
                        }

                        return Text(
                          currencyFormatter(0),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Total Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoaded) {
                          return Text(
                            state.orders.length.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          );
                        }

                        return const Text(
                          '0',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 150,
                ),
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  final button = buttons[index];
                  return DashboardIconButton(
                    icon: button['icon'] as IconData,
                    label: button['label'] as String,
                    destination: button['destination'] as String,
                  );
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(RouteNames.profile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Back to home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String destination;

  const DashboardIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(destination);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              color: Colors.grey.shade50,
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
