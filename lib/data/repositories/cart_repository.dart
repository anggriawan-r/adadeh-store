import 'package:adadeh_store/data/models/cart_model.dart';
import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<CategoryModel?> getCategory(DocumentReference categoryRef) async {
    try {
      final categorySnapshot = await categoryRef.get();
      if (categorySnapshot.exists) {
        return CategoryModel.fromFirestore(categorySnapshot, null);
      } else {
        throw Exception('Category not found');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  Future<Map<String, dynamic>> getCartForUser() async {
    final userId = _auth.currentUser!.uid;
    try {
      final cartSnapshot =
          await _firestore.collection('carts').doc(userId).get();

      if (!cartSnapshot.exists) {
        throw Exception('Cart is empty. Let\'s add some!');
      }

      final cart = CartModel.fromFirestore(cartSnapshot, null);

      final List<Map<String, dynamic>> productsWithCategory = [];

      for (final item in cart.products) {
        final productSnapshot =
            await _firestore.collection('products').doc(item.productId).get();

        if (!productSnapshot.exists) {
          throw Exception('Product not found');
        }

        final product = ProductModel.fromFirestore(productSnapshot, null);
        final category = await getCategory(product.categoryRef);

        productsWithCategory.add({
          'product': product,
          'category': category!.name,
          'quantity': item.quantity,
          'isChecked': item.isChecked,
        });
      }

      return {
        'cart': cart,
        'productsWithCategory': productsWithCategory,
      };
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    final userId = _auth.currentUser!.uid;

    try {
      final cartDocRef = _firestore.collection('carts').doc(userId);

      final cartSnapshot = await cartDocRef.get();
      CartModel cart;
      if (cartSnapshot.exists) {
        cart = CartModel.fromFirestore(cartSnapshot, null);
      } else {
        cart = CartModel(
          id: cartDocRef.id,
          userId: userId,
          products: [],
          date: DateTime.now(),
        );
      }

      final existingItemIndex =
          cart.products.indexWhere((item) => item.productId == productId);
      if (existingItemIndex >= 0) {
        final existingItem = cart.products[existingItemIndex];
        cart.products[existingItemIndex] = CartItem(
          productId: existingItem.productId,
          quantity: existingItem.quantity + quantity,
          isChecked: existingItem.isChecked,
        );
      } else {
        cart.products.add(CartItem(
          productId: productId,
          quantity: quantity,
        ));
      }

      await cartDocRef.set(cart.toFirestore());
    } catch (e) {
      throw Exception('Error adding product to cart: $e');
    }
  }

  Future<void> updateCartItem(String productId, bool isChecked) async {
    final userId = _auth.currentUser!.uid;

    try {
      final cartDocRef = _firestore.collection('carts').doc(userId);

      final cartSnapshot = await cartDocRef.get();
      if (!cartSnapshot.exists) {
        throw Exception('Cart not found');
      }

      final cart = CartModel.fromFirestore(cartSnapshot, null);

      final index =
          cart.products.indexWhere((item) => item.productId == productId);
      if (index >= 0) {
        cart.products[index] = CartItem(
          productId: cart.products[index].productId,
          quantity: cart.products[index].quantity,
          isChecked: isChecked,
        );

        await cartDocRef.set(cart.toFirestore());
      }
    } catch (e) {
      throw Exception('Error updating cart item: $e');
    }
  }

  Future<void> selectAllCartItems(bool isChecked) async {
    final userId = _auth.currentUser!.uid;

    try {
      final cartDocRef = _firestore.collection('carts').doc(userId);
      final cartSnapshot = await cartDocRef.get();

      if (!cartSnapshot.exists) {
        throw Exception('Cart not found');
      }

      final cart = CartModel.fromFirestore(cartSnapshot, null);

      for (final item in cart.products) {
        item.isChecked = isChecked;
      }

      await cartDocRef.set(cart.toFirestore());
    } catch (e) {
      throw Exception('Error selecting all cart items: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    final userId = _auth.currentUser!.uid;
    try {
      final cartDocRef = _firestore.collection('carts').doc(userId);

      final cartSnapshot = await cartDocRef.get();
      if (!cartSnapshot.exists) {
        throw Exception('Cart not found');
      }

      final cart = CartModel.fromFirestore(cartSnapshot, null);

      cart.products.removeWhere((item) => item.productId == productId);

      await cartDocRef.set(cart.toFirestore());
    } catch (e) {
      throw Exception('Error removing product from cart: $e');
    }
  }

  Future<void> incrementCartItemQuantity(String productId) async {
    final userId = _auth.currentUser!.uid;
    try {
      final cartDocRef = _firestore.collection('carts').doc(userId);
      final cartSnapshot = await cartDocRef.get();
      if (!cartSnapshot.exists) {
        throw Exception('Cart not found');
      }

      final cart = CartModel.fromFirestore(cartSnapshot, null);
      final index =
          cart.products.indexWhere((item) => item.productId == productId);
      if (index >= 0) {
        final item = cart.products[index];
        cart.products[index] = CartItem(
          productId: item.productId,
          quantity: item.quantity + 1,
          isChecked: item.isChecked,
        );

        await cartDocRef.set(cart.toFirestore());
      }
    } catch (e) {
      throw Exception('Error incrementing cart item quantity: $e');
    }
  }

  Future<void> decrementCartItemQuantity(String productId) async {
    final userId = _auth.currentUser!.uid;
    try {
      final cartDocRef = _firestore.collection('carts').doc(userId);
      final cartSnapshot = await cartDocRef.get();
      if (!cartSnapshot.exists) {
        throw Exception('Cart not found');
      }

      final cart = CartModel.fromFirestore(cartSnapshot, null);
      final index =
          cart.products.indexWhere((item) => item.productId == productId);
      if (index >= 0) {
        final item = cart.products[index];
        if (item.quantity > 1) {
          cart.products[index] = CartItem(
            productId: item.productId,
            quantity: item.quantity - 1,
            isChecked: item.isChecked,
          );

          await cartDocRef.set(cart.toFirestore());
        } else {
          await removeFromCart(productId);
        }
      }
    } catch (e) {
      throw Exception('Error decrementing cart item quantity: $e');
    }
  }
}
