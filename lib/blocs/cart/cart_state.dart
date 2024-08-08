part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  final List<Map<String, dynamic>> productsWithCategory;

  const CartLoaded(this.cart, this.productsWithCategory);

  @override
  List<Object> get props => [cart, productsWithCategory];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
