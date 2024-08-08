import 'package:adadeh_store/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? _selectedPaymentType;
  String? _selectedEwalletOption;
  String? _selectedBankOption;

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey.withOpacity(0.5),
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
            onPressed: () {
              context.push(RouteNames.payment);
            },
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jotaro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Iconsax.location),
                        SizedBox(width: 8),
                        Text('Boulevard St.'),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://via.placeholder.com/80x80',
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
                            'SANDAL MEHANA',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                          Text(
                            'Lifestyle',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Text(
                            '1 x Rp1.300.000',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Total Price'),
                        Spacer(),
                        Text(
                          'Rp1.300.000',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Shipping cost'),
                        Spacer(),
                        Text(
                          'Rp20.000',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Administration'),
                        Spacer(),
                        Text(
                          'Rp1.000',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text('Total'),
                        Spacer(),
                        Text(
                          'Rp1.321.000',
                          style: TextStyle(
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
                            Text('Bank Transfer'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RadioListTile<String>(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: const Text('BCA'),
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
                          title: const Text('BRI'),
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
                          title: const Text('Mandiri'),
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
                          title: const Text('OVO'),
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
                          title: const Text('GoPay'),
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
  }
}
