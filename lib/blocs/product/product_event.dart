part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProductsWithCategory extends ProductEvent {}

class LoadProductWithCategory extends ProductEvent {
  final String productId;

  const LoadProductWithCategory({required this.productId});

  @override
  List<Object> get props => [productId];
}

// ignore: must_be_immutable
class UpdateProduct extends ProductEvent {
  final String productId;
  final String name;
  final String description;
  final String category;
  XFile? image;
  final int price;
  final int stock;

  UpdateProduct({
    required this.productId,
    required this.name,
    required this.description,
    required this.category,
    this.image,
    required this.price,
    required this.stock,
  });

  @override
  List<Object?> get props => [
        productId,
        name,
        description,
        category,
        image,
        price,
        stock,
      ];
}

class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct({required this.productId});

  @override
  List<Object> get props => [productId];
}

class AddProduct extends ProductEvent {
  final String name;
  final String description;
  final String category;
  final XFile image;
  final int price;
  final int stock;

  const AddProduct({
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    required this.stock,
  });

  @override
  List<Object> get props => [
        name,
        description,
        category,
        image,
        price,
        stock,
      ];
}
