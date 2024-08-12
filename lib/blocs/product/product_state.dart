part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class AllProductsLoaded extends ProductState {
  final List<Map<String, dynamic>> productsWithCategory;

  const AllProductsLoaded(this.productsWithCategory);

  @override
  List<Object> get props => [productsWithCategory];
}

class ProductLoaded extends ProductState {
  final Map<String, dynamic> productWithCategory;

  const ProductLoaded(this.productWithCategory);

  @override
  List<Object> get props => [productWithCategory];
}

class ProductDeleted extends ProductState {}

class ProductError extends ProductState {
  final String error;

  const ProductError({required this.error});

  @override
  List<Object?> get props => [error];
}
