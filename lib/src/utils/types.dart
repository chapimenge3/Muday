enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime dateTime;
  final String category;
  final String icon;
  final bool isExpense;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.category,
    required this.icon,
    required this.isExpense,
  });
}
