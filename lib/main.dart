import 'package:adadeh_store/blocs/auth/auth_bloc.dart';
import 'package:adadeh_store/blocs/cart/cart_bloc.dart';
import 'package:adadeh_store/blocs/product/product_bloc.dart';
import 'package:adadeh_store/blocs/profile/profile_bloc.dart';
import 'package:adadeh_store/firebase_options.dart';
import 'package:adadeh_store/notifications/notification_helper.dart';
import 'package:adadeh_store/routes/app_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationHelper().initLocalNotification();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthStarted()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc()..add(ProfileLoaded()),
        ),
        BlocProvider(
          create: (context) =>
              ProductBloc()..add(LoadAllProductsWithCategory()),
        ),
        BlocProvider(
          create: (context) => CartBloc()..add(LoadCart()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
