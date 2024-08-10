import 'package:adadeh_store/screens/auth/components/auth_form_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RegisterPage2 extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final VoidCallback onPrevious;

  const RegisterPage2({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.onPrevious,
  });

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            AuthFormField(
              controller: widget.nameController,
              label: 'Name',
              prefixIcon: Iconsax.user,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              keyboardType: TextInputType.phone,
              controller: widget.phoneController,
              label: 'Phone',
              prefixIcon: Iconsax.call,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: widget.addressController,
              label: 'Address',
              prefixIcon: Iconsax.location,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
