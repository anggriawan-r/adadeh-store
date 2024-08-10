import 'package:adadeh_store/blocs/auth/auth_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/auth/components/auth_top_bar.dart';
import 'package:adadeh_store/screens/auth/components/progress_bar.dart';
import 'package:adadeh_store/screens/auth/register/register_page_1.dart';
import 'package:adadeh_store/screens/auth/register/register_page_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formPage1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _formPage2Key = GlobalKey<FormState>();

  int _currentPage = 0;

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage++;
    });
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage--;
    });
  }

  void _onSubmit() {
    if (_currentPage == 0 && _formPage1Key.currentState!.validate()) {
      _nextPage();
    } else if (_currentPage == 1 && _formPage2Key.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        AuthRegistered(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Register success. Please login'),
        ),
      );

      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ProgressBar(
                    currentPage: _currentPage,
                    totalPages: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AuthTopBar(
                      iconLabel: 'LOGIN',
                      onPressed: () {
                        context.go(RouteNames.login);
                      }),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'SIGN UP.',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      Form(
                        key: _formPage1Key,
                        child: RegisterPage1(
                          onNext: _nextPage,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ),
                      Form(
                        key: _formPage2Key,
                        child: RegisterPage2(
                          onPrevious: _previousPage,
                          nameController: _nameController,
                          phoneController: _phoneController,
                          addressController: _addressController,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _currentPage == 0
                              ? null
                              : () {
                                  _previousPage();
                                },
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _onSubmit(),
                          child: Text(_currentPage == 1 ? 'SIGN UP' : 'Next'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}
