import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthTopBar extends StatelessWidget {
  final String iconLabel;
  final void Function() onPressed;

  const AuthTopBar({
    super.key,
    required this.iconLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/logo/adadeh.svg',
            semanticsLabel: 'Adadeh Logo',
            height: 48,
            width: 48,
            colorFilter: const ColorFilter.mode(
              Colors.black87,
              BlendMode.srcIn,
            ),
          ),
          IconButton(
            onPressed: onPressed,
            padding: const EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  iconLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
