import 'package:adadeh_store/screens/cart/cart_screen.dart';
import 'package:adadeh_store/screens/landing/landing_screen.dart';
import 'package:adadeh_store/screens/product/product_screen.dart';
import 'package:adadeh_store/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  static const body = <Widget>[
    LandingScreen(),
    ProductScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() => selectedIndex = value),
        backgroundColor: Colors.white,
        indicatorColor: Colors.grey.shade200,
        elevation: 1,
        shadowColor: Colors.black,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home, color: Colors.grey),
            selectedIcon: Icon(Iconsax.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.shop, color: Colors.grey),
            selectedIcon: Icon(Iconsax.shop),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Iconsax.shopping_cart, color: Colors.grey),
            ),
            selectedIcon: Badge(
              label: Text('2'),
              child: Icon(Iconsax.shopping_cart),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user, color: Colors.grey),
            selectedIcon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
      ),
      body: body[selectedIndex],
    );
  }
}
