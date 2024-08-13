import 'package:adadeh_store/data/models/product_model.dart';
import "package:flutter/services.dart";
import 'package:adadeh_store/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<Map<String, dynamic>>> parseCsv(String filePath) async {
  final input = await rootBundle.loadString(filePath);

  final fields = const CsvToListConverter(fieldDelimiter: ';', eol: '\n')
      .convert(input, fieldDelimiter: ';', eol: '\n');

  final headers = fields[0];
  final products = fields.skip(1);

  return products.map((row) {
    final map = <String, dynamic>{};
    for (int i = 0; i < headers.length; i++) {
      map[headers[i]] = row[i];
    }
    return map;
  }).toList();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> products =
      await parseCsv('assets/csv/products.csv');

  for (final product in products) {
    final docRef = firestore.collection('products').doc();

    final productModel = ProductModel(
      id: docRef.id,
      name: product['name'],
      description: product['description'],
      price: product['price'],
      stock: product['stock'],
      imageUrl: product['imageUrl'],
      categoryRef:
          firestore.collection('categories').doc(product['categoryRef']),
    );

    await docRef.set(productModel.toFirestore());

    print('Added product ${product['name']}');
  }

  print('All products added');
}
