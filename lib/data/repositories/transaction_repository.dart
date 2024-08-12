import 'dart:async';

import 'package:adadeh_store/data/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getAllTransactionStream() {
    return _firestore.collection('orders').snapshots().asyncMap(
      (querySnapshot) async {
        final List<OrderModel> transactions = [];

        for (final doc in querySnapshot.docs) {
          final transaction = OrderModel.fromFirestore(doc.data());

          transactions.add(transaction);
        }

        return transactions;
      },
    );
  }
}
