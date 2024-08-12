import 'package:adadeh_store/data/repositories/transaction_repository.dart';
import 'package:adadeh_store/data/models/order_model.dart';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository = TransactionRepository();
  List<OrderModel> _allTransactions = [];
  List<OrderModel> _filteredTransactions = [];

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());

      try {
        await for (final transactions
            in _transactionRepository.getAllTransactionStream()) {
          _allTransactions = transactions;
          _filteredTransactions = transactions;
          emit(TransactionLoaded(_filteredTransactions));
        }
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<FilterTransactions>((event, emit) {
      _applyFilters(
        query: event.query,
        startDate: event.startDate,
        endDate: event.endDate,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );

      emit(TransactionLoaded(_filteredTransactions));
    });
  }

  void _applyFilters({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
  }) {
    _filteredTransactions = _allTransactions.where((transaction) {
      final matchesQuery = query == null ||
          transaction.products.any((product) {
            return product['name'].toLowerCase().contains(query.toLowerCase());
          });

      final matchesDate = (startDate == null ||
              DateTime.parse(transaction.orderDate).isAfter(startDate)) &&
          (endDate == null ||
              DateTime.parse(transaction.orderDate).isBefore(endDate));

      final matchesPrice =
          (minPrice == null || transaction.totalAmount >= minPrice) &&
              (maxPrice == null || transaction.totalAmount <= maxPrice);

      return matchesQuery && matchesDate && matchesPrice;
    }).toList();
  }
}
