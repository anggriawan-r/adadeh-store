part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class SubmitOrder extends OrderEvent {
  final String userId;
  final List<Map<String, dynamic>> products;
  final int totalPrice;
  final int shippingCost;
  final int adminFee;
  final String paymentMethod;

  const SubmitOrder({
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.shippingCost,
    required this.adminFee,
    required this.paymentMethod,
  });

  @override
  List<Object> get props =>
      [userId, products, totalPrice, shippingCost, adminFee, paymentMethod];
}

class LoadOrders extends OrderEvent {}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;
  final List<dynamic>? products;

  const UpdateOrderStatus(
      {required this.orderId, required this.status, this.products});

  @override
  List<Object?> get props => [orderId, status, products];
}
