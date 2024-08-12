import 'package:adadeh_store/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final bool emailVerified;

  const ProfileInfo({
    super.key,
    required this.profile,
    required this.emailVerified,
  });

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: profile.photoUrl.isEmpty
                ? null
                : NetworkImage(profile.photoUrl),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: profile.email,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                emailVerified
                    ? const TextSpan(
                        text: ' (verified)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.green,
                        ),
                      )
                    : const TextSpan(
                        text: ' (not verified)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
          ),
          Text(
            profile.phone,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          profile.address.isNotEmpty
              ? Text(profile.address)
              : const Text(
                  'No address provided. Add one.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
        ],
      ),
    );
  }
}
