import 'package:adadeh_store/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class Shopping extends StatelessWidget {
  const Shopping({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              context.push(RouteNames.cart);
            },
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Iconsax.shopping_cart),
            title: const Text('Cart'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1.0,
          ),
          ListTile(
            onTap: () {
              context.push(RouteNames.orderHistory);
            },
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Iconsax.card),
            title: const Text('Order history'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
