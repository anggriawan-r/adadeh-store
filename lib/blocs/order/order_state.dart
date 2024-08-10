part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderSubmitted extends OrderState {
  final String orderId;

  const OrderSubmitted(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class OrderFailure extends OrderState {
  final String error;

  const OrderFailure(this.error);

  @override
  List<Object> get props => [error];
}
