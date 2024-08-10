import 'package:adadeh_store/routes/route_names.dart';
import 'package:adadeh_store/screens/auth/login/login_screen.dart';
import 'package:adadeh_store/screens/cart/cart_screen.dart';
import 'package:adadeh_store/screens/cart/order_screen.dart';
import 'package:adadeh_store/screens/home/home_screen.dart';
import 'package:adadeh_store/screens/order_history/order_history_screen.dart';
import 'package:adadeh_store/screens/payment/payment_debit_screen.dart';
import 'package:adadeh_store/screens/payment/payment_status_screen.dart';
import 'package:adadeh_store/screens/payment/payment_wallet_screen.dart';
import 'package:adadeh_store/screens/product/product_detail.dart';
import 'package:adadeh_store/screens/product/product_screen.dart';
import 'package:adadeh_store/screens/auth/register/register_screen.dart';
import 'package:adadeh_store/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
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
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
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
  ],
);
