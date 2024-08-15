import 'package:adadeh_store/blocs/order/order_bloc.dart';
import 'package:adadeh_store/data/models/order_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PaymentWalletScreen extends StatelessWidget {
  const PaymentWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = GoRouterState.of(context).extra as OrderModel;

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderUpdated) {
          context.pushReplacement(
            '${RouteNames.paymentWallet}/payment-status',
            extra: state.order,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'E-Wallet Payment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Payment',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    currencyFormatter(order.totalAmount.toInt()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SvgPicture.asset(
                    'assets/icons/qrcode.svg',
                    height: 200,
                    semanticsLabel: 'QR Code',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Send payment request',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(UpdateOrderStatus(
                        orderId: order.id, status: 'success'));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirm Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
