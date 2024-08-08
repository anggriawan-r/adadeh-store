part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCart(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class UpdateCartItem extends CartEvent {
  final String productId;
  final bool isChecked;

  const UpdateCartItem(this.productId, this.isChecked);

  @override
  List<Object> get props => [productId, isChecked];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class IncrementQuantity extends CartEvent {
  final String productId;

  const IncrementQuantity(this.productId);

  @override
  List<Object> get props => [productId];
}

class DecrementQuantity extends CartEvent {
  final String productId;

  const DecrementQuantity(this.productId);

  @override
  List<Object> get props => [productId];
}
