import 'package:adadeh_store/data/models/order_model.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:adadeh_store/utils/pdf_generator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({super.key});

  String getStatusText(String status) {
    if (status == 'success') {
      return 'Payment Success!';
    } else if (status == 'cancelled') {
      return 'Cancelled';
    } else if (status == 'pending') {
      return 'Pending';
    }

    return 'Payment Failed!';
  }

  @override
  Widget build(BuildContext context) {
    final order = GoRouterState.of(context).extra as OrderModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Payment Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    if (order.status == 'success')
                      const Column(
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            size: 76,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    Text(
                      getStatusText(order.status),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      currencyFormatter(order.totalAmount.toInt()),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 32),
                    RowText(
                      label: 'Payment Method',
                      value: order.paymentMethod.toUpperCase(),
                    ),
                    const SizedBox(height: 8),
                    RowText(label: 'Status', value: order.status.toUpperCase()),
                    const SizedBox(height: 8),
                    RowText(
                      label: 'Transaction ID',
                      value: order.id,
                    ),
                    const SizedBox(height: 8),
                    RowText(
                      label: 'Customer ID',
                      value: '${order.userId.substring(0, 16)} ...',
                    ),
                    const SizedBox(height: 8),
                    RowText(
                      label: 'Transaction Date',
                      value: DateTime.parse(order.orderDate)
                          .toLocal()
                          .toString()
                          .substring(0, 19),
                    ),
                    const Divider(height: 32),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    final product = order.products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ProductList(
                        price: product['price'],
                        productName: product['name'],
                        quantity: product['quantity'],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text(
                          currencyFormatter(order.totalPrice.toInt()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shipping cost'),
                        Text(
                          currencyFormatter(order.shippingCost.toInt()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Admin fee'),
                        Text(
                          currencyFormatter(order.adminFee.toInt()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text(
                          currencyFormatter(order.totalAmount.toInt()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await PdfGenerator(order).generatePdf('invoice');

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('PDF saved successfully')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.document_download,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Save to PDF'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go(RouteNames.landing);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Go to home'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  final String label;
  final String value;

  const RowText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ProductList extends StatelessWidget {
  final String productName;
  final int quantity;
  final int price;

  const ProductList({
    super.key,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$quantity x ${currencyFormatter(price)}',
            ),
          ],
        ),
        Text(
          currencyFormatter(quantity * price),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
