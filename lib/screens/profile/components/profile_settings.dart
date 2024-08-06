import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

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
            onTap: () {},
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Iconsax.sms),
            title: const Text('Verify email'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1.0,
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Iconsax.location),
            title: const Text('Add/change address'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1.0,
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Iconsax.call),
            title: const Text('Change phone number'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
