import 'package:adadeh_store/data/repositories/product_repository.dart';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository = ProductRepository();

  ProductBloc() : super(ProductInitial()) {
    on<LoadProductsWithCategory>((event, emit) async {
      emit(ProductLoading());

      try {
        await for (final productsWithCategories
            in _productRepository.getAllProductsWithCategoryStream()) {
          emit(ProductLoaded(productsWithCategories));
        }
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });
  }
}
