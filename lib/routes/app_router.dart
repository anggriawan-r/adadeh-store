import 'package:adadeh_store/blocs/auth/auth_bloc.dart';
import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/admin/dashboard/dashboard_screen.dart';
import 'package:adadeh_store/screens/admin/product/add_product_screen.dart';
import 'package:adadeh_store/screens/admin/product/admin_product_screen.dart';
import 'package:adadeh_store/screens/admin/product/edit_product_screen.dart';
import 'package:adadeh_store/screens/auth/login/login_screen.dart';
import 'package:adadeh_store/screens/cart/cart_screen.dart';
import 'package:adadeh_store/screens/cart/order_screen.dart';
import 'package:adadeh_store/screens/home/home_screen.dart';
import 'package:adadeh_store/screens/landing/landing_screen.dart';
import 'package:adadeh_store/screens/order_history/order_history_screen.dart';
import 'package:adadeh_store/screens/payment/payment_debit_screen.dart';
import 'package:adadeh_store/screens/payment/payment_status_screen.dart';
import 'package:adadeh_store/screens/payment/payment_wallet_screen.dart';
import 'package:adadeh_store/screens/product/product_detail.dart';
import 'package:adadeh_store/screens/product/product_screen.dart';
import 'package:adadeh_store/screens/auth/register/register_screen.dart';
import 'package:adadeh_store/screens/profile/profile_screen.dart';
import 'package:adadeh_store/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.splash,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          routes: [
            GoRoute(
              path: '/landing',
              builder: (context, state) => const LandingScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.product,
              builder: (context, state) => const ProductScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final String id = state.pathParameters['id']!;
                    return ProductDetail(id: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.cart,
              builder: (context, state) => const CartScreen(),
              routes: [
                GoRoute(
                  path: RouteNames.order,
                  builder: (context, state) => const OrderScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.paymentDebit,
      builder: (context, state) => const PaymentDebitScreen(),
      routes: [
        GoRoute(
          path: RouteNames.paymentStatus,
          builder: (context, state) => const PaymentStatusScreen(),
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.paymentWallet,
      builder: (context, state) => const PaymentWalletScreen(),
      routes: [
        GoRoute(
          path: RouteNames.paymentStatus,
          builder: (context, state) => const PaymentStatusScreen(),
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.orderHistory,
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: RouteNames.adminDashboard,
      builder: (context, state) => AdminDashboardScreen(),
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state as AuthAuthenticated;

        if (authState.profile.role != 'admin') {
          return RouteNames.landing;
        }

        return null;
      },
    ),
    GoRoute(
      path: RouteNames.adminProduct,
      builder: (context, state) => const AdminProductScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            return ProductDetail(id: id);
          },
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            return EditProductScreen(id: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.addProduct,
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: RouteNames.adminCustomer,
      builder: (context, state) => const AdminProductScreen(),
    ),
    GoRoute(
      path: RouteNames.adminTransaction,
      builder: (context, state) => const AdminProductScreen(),
    ),
  ],
);
