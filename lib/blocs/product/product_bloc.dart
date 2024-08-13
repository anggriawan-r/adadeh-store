// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adadeh_store/data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository = ProductRepository();

  List<Map<String, dynamic>> _productsWithCategory = [];
  List<Map<String, dynamic>> _filteredProductsWithCategory = [];

  ProductBloc() : super(ProductInitial()) {
    on<LoadAllProductsWithCategory>((event, emit) async {
      emit(ProductLoading());

      try {
        await for (final productsWithCategory
            in _productRepository.getAllProductsWithCategoryStream()) {
          _productsWithCategory = productsWithCategory;
          _filteredProductsWithCategory = productsWithCategory;

          emit(AllProductsLoaded(_filteredProductsWithCategory));
        }
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });

    on<FilterProducts>((event, emit) async {
      _applyFilter(
        query: event.query,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );

      emit(AllProductsLoaded(_filteredProductsWithCategory));
    });

    on<LoadProductWithCategory>((event, emit) async {
      emit(ProductLoading());

      try {
        final product =
            await _productRepository.getProductWithCategory(event.productId);

        if (product['product'] == null || product['category'] == null) {
          throw Exception('Product or category not found');
        }

        emit(ProductLoaded(product));
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });

    on<AddProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await _productRepository.addProduct(
          image: event.image,
          name: event.name,
          description: event.description,
          category: event.category,
          price: event.price,
          stock: event.stock,
        );

        add(LoadAllProductsWithCategory());
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });

    on<UpdateProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await _productRepository.updateProduct(
          productId: event.productId,
          image: event.image,
          name: event.name,
          description: event.description,
          category: event.category,
          price: event.price,
          stock: event.stock,
        );

        add(LoadAllProductsWithCategory());
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });

    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await _productRepository.deleteProduct(event.productId);
        emit(ProductDeleted());
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });
  }

  void _applyFilter({
    String? query,
    double? minPrice,
    double? maxPrice,
  }) {
    _filteredProductsWithCategory = _productsWithCategory.where((item) {
      final product = item['product'] as ProductModel;

      final matchesQuery = query == null ||
          product.name.toLowerCase().contains(query.toLowerCase());

      final matchesPrice = (minPrice == null || product.price >= minPrice) &&
          (maxPrice == null || product.price <= maxPrice);

      return matchesQuery && matchesPrice;
    }).toList();
  }
}
