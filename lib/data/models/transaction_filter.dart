class TransactionFilter {
  final String? productName;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionFilter({
    this.productName,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'category': category,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory TransactionFilter.fromMap(Map<String, dynamic> map) {
    return TransactionFilter(
      productName: map['productName'],
      category: map['category'],
      minPrice: map['minPrice'],
      maxPrice: map['maxPrice'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}
