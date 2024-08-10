import 'package:adadeh_store/screens/auth/components/auth_form_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RegisterPage1 extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onNext;

  const RegisterPage1({
    super.key,
    required this.onNext,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  bool _obscureText = true;

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
              controller: widget.emailController,
              label: 'Email',
              prefixIcon: Iconsax.sms,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: widget.passwordController,
              label: 'Password',
              prefixIcon: Iconsax.lock,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              obscureText: _obscureText,
              onPressedSuffixIcon: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
