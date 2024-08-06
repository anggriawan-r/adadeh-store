import 'package:adadeh_store/blocs/auth/auth_bloc.dart';
import 'package:adadeh_store/blocs/profile/profile_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/profile/components/profile_card.dart';
import 'package:adadeh_store/screens/profile/components/profile_info.dart';
import 'package:adadeh_store/screens/profile/components/profile_settings.dart';
import 'package:adadeh_store/screens/profile/components/shopping.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoadedSuccess) {
            final profile = state.profile;
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileInfo(
                          profile: profile,
                          firebaseAuth: firebaseAuth,
                        ),
                        const SizedBox(height: 16),
                        const Shopping(),
                        const SizedBox(height: 16),
                        const ProfileSettings(),
                        const SizedBox(height: 16),
                        ProfileCard(
                          text: 'Logout',
                          icon: Iconsax.logout,
                          state: context.read<AuthBloc>().state,
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLoggedOut());

                            final authState = context.read<AuthBloc>().state;

                            if (authState is AuthUnauthenticated) {
                              context.go(RouteNames.login);
                            } else if (authState is AuthFailure) {
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(authState.error),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }
}
