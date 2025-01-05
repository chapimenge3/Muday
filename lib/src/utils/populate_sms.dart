// write me void async fun
import 'package:muday/src/models/db.dart';
import 'package:muday/src/services/sms/sms_service.dart';

Future<void> populateSms() async {
  final smsService = SMSService();
  final db = DatabaseService.instance;

  // Uncomment to delete all transactions
  // await db.delete('transactions', '1=1', []);

  var txn = await db.query('transactions');
  // if there are transactions in the database, don't populate
  if (txn.isNotEmpty) {
    print('Database already populated with ${txn.length} transactions');
    return;
  }
  print('Database is empty. Populating...');
  int total = 0;
  int count = 10;
  int offset = 0;
  while (true) {
    var txns = await smsService.getParsedCBETransaction(
        count: count, offset: offset, includeReceipt: true);
    if (txns.isEmpty) {
      break;
    }
    for (var txn in txns) {
      var mapped = txn.toMap();
      db.insert('transactions', mapped);
      print('!!Inserted transaction: $mapped');
      print('-' * 50);
    }
    offset += count;
    total += txns.length;
    print('Total transactions: $total so far');
  }
  print('Total transactions: $total in the database');
}
