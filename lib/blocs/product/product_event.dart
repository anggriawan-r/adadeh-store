part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProductsWithCategory extends ProductEvent {}

class LoadProductWithCategory extends ProductEvent {
  final String productId;

  const LoadProductWithCategory({required this.productId});

  @override
  List<Object> get props => [productId];
}
