import 'package:adadeh_store/data/models/category_model.dart';
import 'package:adadeh_store/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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

  Stream<List<Map<String, dynamic>>> getAllProductsWithCategoryStream() {
    return _firebaseFirestore.collection('products').snapshots().asyncMap(
      (querySnapshot) async {
        final List<Map<String, dynamic>> productsWithCategories = [];

        for (final doc in querySnapshot.docs) {
          final product = ProductModel.fromFirestore(doc, null);
          final category = await getCategory(product.categoryRef);

          productsWithCategories.add({
            'product': product,
            'category': category,
          });
        }

        return productsWithCategories;
      },
    );
  }
}
