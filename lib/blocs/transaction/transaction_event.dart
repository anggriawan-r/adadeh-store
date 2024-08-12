part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class FilterTransactions extends TransactionEvent {
  final String? query;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minPrice;
  final double? maxPrice;

  const FilterTransactions({
    this.query,
    this.startDate,
    this.endDate,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [query, startDate, endDate, minPrice, maxPrice];
}
