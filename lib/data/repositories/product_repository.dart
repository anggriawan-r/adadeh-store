import 'dart:io';

import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProductRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Stream<ProductModel> getProductStream(String productId) {
    return _firebaseFirestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map(
      (snapshot) {
        if (snapshot.exists) {
          return ProductModel.fromFirestore(snapshot, null);
        } else {
          throw Exception('Product not found');
        }
      },
    );
  }

  Future<CategoryModel?> getCategory(DocumentReference categoryRef) async {
    try {
      final DocumentSnapshot categorySnapshot = await categoryRef.get();
      if (categorySnapshot.exists) {
        return CategoryModel.fromFirestore(categorySnapshot, null);
      } else {
        throw Exception('Category not found');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  Future<Map<String, dynamic>> getProductWithCategory(String productId) async {
    try {
      final productsRef = _firebaseFirestore.collection('products');
      final productSnapshot = await productsRef.doc(productId).get();

      if (!productSnapshot.exists) {
        throw Exception('Product not found');
      }

      final product = ProductModel.fromFirestore(productSnapshot, null);
      final category = await getCategory(product.categoryRef);

      return {
        'product': product,
        'category': category,
      };
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getAllProductsWithCategoryStream() {
    return _firebaseFirestore.collection('products').snapshots().asyncMap(
      (querySnapshot) async {
        final List<Map<String, dynamic>> productsWithCategory = [];

        for (final doc in querySnapshot.docs) {
          final product = ProductModel.fromFirestore(doc, null);
          final category = await getCategory(product.categoryRef);

          productsWithCategory.add({
            'product': product,
            'category': category,
          });
        }

        return productsWithCategory;
      },
    );
  }

  Future<void> substractStock(String productId, int quantity) async {
    if (quantity < 0) {
      throw Exception('Invalid quantity');
    }

    final doc =
        await _firebaseFirestore.collection('products').doc(productId).get();
    final product = ProductModel.fromFirestore(doc, null);

    if (product.stock < quantity) {
      throw Exception('Stock is not enough');
    }

    await _firebaseFirestore
        .collection('products')
        .doc(productId)
        .update({'stock': FieldValue.increment(-quantity)});
  }

  Future<void> addStock(String productId, int quantity) async {
    if (quantity < 0) {
      throw Exception('Invalid quantity');
    }

    await _firebaseFirestore
        .collection('products')
        .doc(productId)
        .update({'stock': FieldValue.increment(quantity)});
  }

  Future<void> deleteProduct(String productId) async {
    await deleteImage(productId);
    await _firebaseFirestore.collection('products').doc(productId).delete();
  }

  Future<void> updateProduct({
    required String productId,
    XFile? image,
    required String name,
    required String description,
    required String category,
    required int price,
    required int stock,
  }) async {
    final productRef = _firebaseFirestore.collection('products').doc(productId);

    String downloadUrl;
    if (image != null) {
      await deleteImage(productRef.id);
      downloadUrl = await uploadImage(image, productRef.id);
    } else {
      final doc =
          await _firebaseFirestore.collection('products').doc(productId).get();
      downloadUrl = ProductModel.fromFirestore(doc, null).imageUrl;
    }

    final product = ProductModel(
      id: productRef.id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      imageUrl: downloadUrl,
      categoryRef: FirebaseFirestore.instance
          .collection('categories')
          .doc(category.toLowerCase()),
    );

    await _firebaseFirestore
        .collection('products')
        .doc(productRef.id)
        .set(product.toFirestore());
  }

  Future<void> addProduct({
    required XFile image,
    required String name,
    required String description,
    required String category,
    required int price,
    required int stock,
  }) async {
    final productRef = _firebaseFirestore.collection('products').doc();

    final downloadUrl = await uploadImage(image, productRef.id);

    final product = ProductModel(
      id: productRef.id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      imageUrl: downloadUrl,
      categoryRef: FirebaseFirestore.instance
          .collection('categories')
          .doc(category.toLowerCase()),
    );

    await _firebaseFirestore
        .collection('products')
        .doc(productRef.id)
        .set(product.toFirestore());
  }

  Future<String> uploadImage(XFile image, String productId) async {
    final storageRef = storage.ref();
    final productImageRef = storageRef.child('products/$productId');

    try {
      await productImageRef.putFile(File(image.path));
      final downloadUrl = await productImageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> deleteImage(String productId) async {
    final storageRef = storage.ref();
    final productImageRef = storageRef.child('products/$productId');

    try {
      await productImageRef.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }
}
