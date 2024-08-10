import 'package:adadeh_store/data/models/cart_model.dart';
import 'package:adadeh_store/data/repositories/cart_repository.dart';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository = CartRepository();

  CartBloc() : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final cartData = await _cartRepository.getCartForUser();
        final cart = cartData['cart'] as CartModel;
        final productsWithCategory =
            cartData['productsWithCategory'] as List<Map<String, dynamic>>;

        if (cart.products.isEmpty) {
          emit(CartEmpty());
          return;
        }

        emit(CartLoaded(cart, productsWithCategory));
      } catch (e) {
        emit(CartError('Error fetching cart: $e'));
      }
    });

    on<AddToCart>((event, emit) async {
      emit(CartLoading());
      try {
        await _cartRepository.addToCart(event.productId, event.quantity);

        add(LoadCart());
      } catch (e) {
        emit(CartError('Error adding product to cart: $e'));
      }
    });

    on<UpdateCartItem>((event, emit) async {
      final currentState = state;

      if (currentState is CartLoaded) {
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.productsWithCategory);

        final index = updatedProducts
            .indexWhere((item) => item['product'].id == event.productId);

        if (index != -1) {
          updatedProducts[index] = {
            ...updatedProducts[index],
            'isChecked': event.isChecked,
          };
          emit(CartLoaded(currentState.cart, updatedProducts));
        }

        _cartRepository
            .updateCartItem(event.productId, event.isChecked)
            .catchError((e) {
          emit(CartError('Error updating cart item: $e'));
          add(LoadCart()); // Reload cart if update fails
        });
      }
    });

    on<RemoveFromCart>((event, emit) async {
      final currentState = state;

      if (currentState is CartLoaded) {
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.productsWithCategory);

        final index = updatedProducts
            .indexWhere((item) => item['product'].id == event.productId);

        if (index != -1) {
          updatedProducts.removeAt(index);
          emit(CartLoaded(currentState.cart, updatedProducts));
        }

        _cartRepository.removeFromCart(event.productId).catchError((e) {
          emit(CartError('Error removing product from cart: $e'));
          add(LoadCart());
        });
      }
    });

    on<IncrementQuantity>((event, emit) async {
      final currentState = state;

      if (currentState is CartLoaded) {
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.productsWithCategory);
        final index = updatedProducts
            .indexWhere((item) => item['product'].id == event.productId);

        if (index != -1) {
          final item = updatedProducts[index];
          updatedProducts[index] = {
            ...item,
            'quantity': item['quantity'] + 1,
          };
          emit(CartLoaded(currentState.cart, updatedProducts));
        }

        _cartRepository
            .incrementCartItemQuantity(event.productId)
            .catchError((e) {
          emit(CartError('Error incrementing cart item quantity: $e'));
          add(LoadCart());
        });
      }
    });

    on<DecrementQuantity>((event, emit) async {
      final currentState = state;

      if (currentState is CartLoaded) {
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.productsWithCategory);
        final index = updatedProducts
            .indexWhere((item) => item['product'].id == event.productId);

        if (index != -1) {
          final item = updatedProducts[index];
          if (item['quantity'] > 1) {
            updatedProducts[index] = {
              ...item,
              'quantity': item['quantity'] - 1,
            };
            emit(CartLoaded(currentState.cart, updatedProducts));
          } else {
            updatedProducts.removeAt(index);
            emit(CartLoaded(currentState.cart, updatedProducts));
          }
        }

        _cartRepository
            .decrementCartItemQuantity(event.productId)
            .catchError((e) {
          emit(CartError('Error decrementing cart item quantity: $e'));
          add(LoadCart());
        });
      }
    });

    on<SelectAllCarts>((event, emit) async {
      final currentState = state;

      if (currentState is CartLoaded) {
        final updatedProducts =
            List<Map<String, dynamic>>.from(currentState.productsWithCategory)
                .map((item) {
          return {...item, 'isChecked': event.isChecked};
        }).toList();

        emit(CartLoaded(currentState.cart, updatedProducts));

        _cartRepository.selectAllCartItems(event.isChecked).catchError((e) {
          emit(CartError('Error updating cart item: $e'));
          add(LoadCart());
        });
      }
    });
  }
}
