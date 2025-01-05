import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:muday/src/models/transaction.dart';
import 'package:muday/src/services/sms/cbe_sms_parser.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSService {
  final SmsQuery _query = SmsQuery();
  final List<String> _targetSenders = ['127', 'CBE'];

  // count is the number of messages to read if -1 read all messages
  Future<List<SmsMessage>> readMessages(String address,
      {int count = -1, start = 0}) async {
    var permission = await Permission.sms.status;
    if (!permission.isGranted) {
      permission = await Permission.sms.request();
      if (!permission.isGranted) return [];
    }
    if (count == -1) {
      print('Reading all messages');
      return await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        address: address,
        start: start,
        count: count == -1 ? 100 : count,
      );
    } else {
      return await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        address: address,
        count: count,
        start: start,
      );
    }
  }

  // read all CBE messages and parse them and convert them to TransactionCls and return it as a list
  Future<List<TransactionCls>> getParsedCBETransaction(
      {int count = -1, offset = 0, bool includeReceipt = false}) async {
    // print('Reading CBE messages with count: $count');
    var messages = await readMessages('CBE', count: count, start: offset);
    // print('Total messages: ${messages.length}');
    List<TransactionCls> transactions = [];
    for (var message in messages) {
      try {
        var msg = await CBEReceiptParser.parseMessage(
            message.body ?? '', message.date,
            includeReceipt: includeReceipt);
        if (msg == null) {
          print('ERROR: Failed to parse message: ${message.body}');
          continue;
        }

        transactions.add(TransactionCls(
          id: msg['id'] ?? '',
          wallet: msg['wallet'] == 'CBE'
              ? TransactionWallet.CBE
              : TransactionWallet.TELEBIRR,
          type: msg['type'] == 'debited'
              ? TransactionType.DEBITED
              : TransactionType.CREDITED,
          amount: double.parse(msg['amount'] ?? '0'),
          serviceFee: double.parse(msg['serviceFee'] ?? '0'),
          vat: double.parse(msg['vat'] ?? '0'),
          date: message.date,
          referenceNumber: msg['referenceNumber'],
          payer: msg['payer'],
          payerAccount: msg['payerAccount'],
          receiver: msg['receiver'],
          receiverAccount: msg['receiverAccount'],
          reason: msg['reason'],
          status: TransactionStatus.COMPLETED,
          channel: msg['channel'],
        ));
      } catch (e) {
        print('Error parsing message: $e and msg: ${message.body}');
      }
    }
    print('Total transactions: ${transactions.length}');
    return transactions;
  }
}
