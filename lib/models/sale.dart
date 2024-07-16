class Sale {
  final int farmId;
  final int eggCount;
  final int henCount;
  final double pricePerEgg;
  final double pricePerHen;
  final double totalAmount;

  Sale({
    required this.farmId,
    required this.eggCount,
    required this.henCount,
    required this.pricePerEgg,
    required this.pricePerHen,
    required this.totalAmount,
    required String transactionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'eggCount': eggCount,
      'henCount': henCount,
      'pricePerEgg': pricePerEgg,
      'pricePerHen': pricePerHen,
      'totalAmount': totalAmount,
    };
  }
}
