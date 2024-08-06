part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Map<String, dynamic>> productsWithCategories;

  const ProductLoaded(this.productsWithCategories);

  @override
  List<Object> get props => [productsWithCategories];
}

class ProductError extends ProductState {
  final String error;

  const ProductError({required this.error});

  @override
  List<Object?> get props => [error];
}
