import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  bool obscureText;
  final void Function()? onPressedSuffixIcon;
  final String? Function(String?)? validator;
  TextInputType? keyboardType;

  AuthFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    required this.obscureText,
    this.onPressedSuffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xff232323),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onPressedSuffixIcon,
                icon: obscureText
                    ? const Icon(
                        Iconsax.eye,
                        color: Color(0xff232323),
                      )
                    : const Icon(
                        Iconsax.eye_slash,
                        color: Color(0xff232323),
                      ),
              )
            : null,
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }
}
