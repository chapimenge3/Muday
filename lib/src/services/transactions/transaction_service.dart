import 'package:muday/src/models/db.dart';
import 'package:muday/src/models/transaction.dart';

class TransactionService {
  final db = DatabaseService.instance;
  List<TransactionCls>? _transactions;
  String errorText = '';

  // get error message
  String getError() {
    return errorText;
  }

  Future<List<TransactionCls>> getAllTransactions(
      {int count = -1, int offset = 0}) async {
    try {
      if (_transactions != null) return _transactions!;

      final transactions = await db.query(
        'transactions',
        limit: count == -1 ? null : count,
        offset: offset,
      );

      _transactions =
          transactions.map((json) => TransactionCls.fromJson(json)).toList();
      return _transactions!;
    } catch (e) {
      errorText = e.toString();
      print('Error: $e');
    }
    return [];
  }

  Future<TransactionCls?> getTransactionById(String id) async {
    try {
      final transaction = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (transaction.isNotEmpty) {
        return TransactionCls.fromJson(transaction.first);
      } else {
        return null;
      }
    } catch (e) {
      errorText = e.toString();
      print('Error: $e');
      return null;
    }
  }
}
