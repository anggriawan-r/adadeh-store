import 'package:adadeh_store/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final AuthState? state;

  const ProfileCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 24,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon),
        title: Text(text),
        trailing: isLoading(),
      ),
    );
  }

  Widget isLoading() {
    if (state is AuthLoading) {
      return const CircularProgressIndicator(
        strokeWidth: 1,
      );
    } else {
      return const Icon(Icons.arrow_forward_ios);
    }
  }
}
