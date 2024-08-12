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
  final OrderModel order;

  const OrderSubmitted(this.order);

  @override
  List<Object> get props => [order];
}

class OrderUpdated extends OrderState {
  final OrderModel order;

  const OrderUpdated(this.order);

  @override
  List<Object> get props => [order];
}

class OrderFailure extends OrderState {
  final String error;

  const OrderFailure(this.error);

  @override
  List<Object> get props => [error];
}
