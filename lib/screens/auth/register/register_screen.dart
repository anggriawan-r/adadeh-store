import 'package:adadeh_store/blocs/auth/auth_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/auth/components/auth_form_field.dart';
import 'package:adadeh_store/screens/auth/components/auth_top_bar.dart';
import 'package:adadeh_store/screens/auth/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Registration success. You can login now.',
                ),
              ),
            );

            context.go(RouteNames.login);
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthTopBar(
                        iconLabel: 'LOG IN',
                        onPressed: () => context.go(RouteNames.login),
                      ),
                      const Spacer(),
                      const Text(
                        'SIGN UP.',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 32),
                      AuthFormField(
                        controller: _nameController,
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
                        controller: _phoneController,
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
                        controller: _emailController,
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
                        controller: _passwordController,
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
                      const SizedBox(height: 32),
                      SubmitButton(
                        text: 'SIGN UP',
                        onPressed: () {
                          if (state is AuthLoading) {
                            return;
                          }

                          if (_registerFormKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthRegistered(
                                    name: _nameController.text,
                                    phone: _phoneController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                        state: state,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
