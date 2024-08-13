// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:adadeh_store/data/models/order_model.dart';
import 'package:adadeh_store/data/repositories/product_repository.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProductRepository _productRepository = ProductRepository();

  OrderBloc() : super(OrderInitial()) {
    on<SubmitOrder>((event, emit) async {
      emit(OrderLoading());

      try {
        final orderRef = _firestore.collection('orders').doc();

        final totalAmount =
            event.totalPrice + event.shippingCost + event.adminFee;
        final orderDate = DateTime.now().toUtc();

        final products = event.products.map((productMap) {
          final productModel = productMap['product'] as ProductModel;
          return {
            'productId': productModel.id,
            'name': productModel.name,
            'price': productModel.price,
            'quantity': productMap['quantity'],
            'category': productMap['category'],
          };
        }).toList();

        final orderData = OrderModel(
          id: orderRef.id,
          userId: event.userId,
          products: products,
          totalPrice: event.totalPrice.toDouble(),
          shippingCost: event.shippingCost.toDouble(),
          adminFee: event.adminFee.toDouble(),
          totalAmount: totalAmount.toDouble(),
          paymentMethod: event.paymentMethod,
          orderDate: orderDate.toString(),
          status: 'pending',
        );

        await orderRef.set(orderData.toFirestore());

        for (final product in products) {
          await _productRepository.substractStock(
              product['productId'], product['quantity'] as int);
        }

        emit(OrderSubmitted(orderData));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });

    on<LoadOrders>((event, emit) async {
      emit(OrderLoading());

      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        final ordersRef =
            _firestore.collection('orders').where('userId', isEqualTo: userId);

        final snapshot = await ordersRef.get();

        final orders = snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc.data()))
            .toList();

        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });

    on<UpdateOrderStatus>((event, emit) async {
      emit(OrderLoading());

      try {
        final orderRef = _firestore.collection('orders').doc(event.orderId);
        await orderRef.update({'status': event.status});

        if (event.status == 'cancelled') {
          for (final product in event.products!) {
            await _productRepository.addStock(
                product['productId'] as String, product['quantity'] as int);
          }
        }

        // final orderSnapshot = await orderRef.get();
        // final orderData = OrderModel.fromFirestore(orderSnapshot.data()!);

        add(LoadOrders());
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });
  }
}
