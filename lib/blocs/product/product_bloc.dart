// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adadeh_store/data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository = ProductRepository();

  ProductBloc() : super(ProductInitial()) {
    on<LoadAllProductsWithCategory>((event, emit) async {
      emit(ProductLoading());

      try {
        await for (final productsWithCategory
            in _productRepository.getAllProductsWithCategoryStream()) {
          emit(AllProductsLoaded(productsWithCategory));
        }
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
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
}
