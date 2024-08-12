// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:adadeh_store/data/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());

      final categoryRef = _firestore.collection('categories');

      final categorySnapshot = await categoryRef.get();

      final categories = categorySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc, null))
          .toList();

      emit(CategoryLoaded(categories));
    });
  }
}
