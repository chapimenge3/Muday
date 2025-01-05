import 'package:muday/src/utils/cbe_client.dart';
import 'package:uuid/uuid.dart';
// import 'package:muday/src/utils/cbe_client.dart';

final client = CBEHttpClient();

class CBEReceiptParser {
  // final CBEHttpClient _client;

  // CBEReceiptParser({CBEHttpClient? client})
  //     : _client = client ?? CBEHttpClient();

  static final RegExp namePattern = RegExp(r'Dear\s+(\w+)');
  static final RegExp accountPattern = RegExp(r'Account\s+(\d\*+\d+)');
  static final RegExp amountPattern =
      RegExp(r'(?:Credited|debited)\s+with\s+ETB\s*([\d,]+\.\d{2})');
  static final RegExp balancePattern =
      RegExp(r'Current\s+Balance\s+is\s+ETB\s*([\d,]+\.\d{2})');
  static final RegExp linkPattern = RegExp(r'(https://[^\s]+)');
  static final RegExp idPattern = RegExp(r'id=(FT\w+)');
  static final RegExp _serviceChargePattern =
      RegExp(r'Commission or Service Charge\n([\d,.]+)\s*ETB');
  static final RegExp _vatPattern =
      RegExp(r'15% VAT on Commission\n([\d,.]+)\s*ETB');

  static Future<Map<String, String?>?> parseMessage(
      String message, DateTime? date,
      {bool includeReceipt = true}) async {
    Map<String, String?> parsedMessage = {};
    try {
      var link = linkPattern.firstMatch(message)?.group(1);
      // if link is null or empty or '?id=' is not found in the link return null
      // old message that doesn't contain links Dear Customer your Account 1********6058 has been credited with ETB 48801.89. Your Current Balance is ETB 79601.84. Thank you for Banking with CBE!
      // important phrases: 'Dear Customer your Account' 'has been credited with' 'Your Current Balance is' 'Thank you for Banking with CBE!'
      // and date of the message must be less than April 2023 to be considered a valid old message
      if (link == null || link.isEmpty || !link.contains('?id=')) {
        // any message that starts with 'Dear * your Account * has been' and doesn't contain a link is considered an old message
        if (message.startsWith(RegExp(
            'Dear\\s+\\w+\\s+your\\s+Account\\s+\\d\\*+\\d+\\s+has\\s+been'))) {
          // print('Old message detected: $message');
          link = null;
        } else {
          return null;
        }
      }
      // print('Parsing message: $message');

      parsedMessage['id'] = idPattern.firstMatch(message)?.group(1);
      parsedMessage['name'] = namePattern.firstMatch(message)?.group(1);
      parsedMessage['account'] = accountPattern.firstMatch(message)?.group(1);
      parsedMessage['amount'] = amountPattern.firstMatch(message)?.group(1);
      parsedMessage['balance'] = balancePattern.firstMatch(message)?.group(1);
      parsedMessage['link'] = linkPattern.firstMatch(message)?.group(1);
      parsedMessage['referenceNumber'] =
          idPattern.firstMatch(message)?.group(1);
      parsedMessage['date'] = date?.toIso8601String();
      parsedMessage['type'] =
          message.contains('debited') ? 'debited' : 'credited';
      parsedMessage['wallet'] = 'CBE';
      parsedMessage['serviceFee'] =
          _serviceChargePattern.firstMatch(message)?.group(1);
      parsedMessage['vat'] = _vatPattern.firstMatch(message)?.group(1);

      // if amount is not found try finding with 'has been credited/debited with ETB 9000.00.' pattern
      if (parsedMessage['amount'] == null) {
        final amountPattern2 = RegExp(r'with\s+ETB\s*([\d,]+\.\d{0,2})');
        parsedMessage['amount'] = amountPattern2.firstMatch(message)?.group(1);
      }

      if (parsedMessage['id'] == null) {
        // assign a random id if the uuid is null
        parsedMessage['id'] = Uuid().v4().split('-').first;

        if (parsedMessage['amount'] == null) {
          // if amount is not found, return null
          print('Amount not found in message: $message');
        }
      }

      // replace all commas and ETB in the amount, balance, serviceFee and vat
      parsedMessage['amount'] = parsedMessage['amount']
          ?.replaceAll(',', '')
          .replaceAll('ETB', '')
          .trim();
      parsedMessage['balance'] = parsedMessage['balance']
          ?.replaceAll(',', '')
          .replaceAll('ETB', '')
          .trim();
      parsedMessage['serviceFee'] = parsedMessage['serviceFee']
          ?.replaceAll(',', '')
          .replaceAll('ETB', '')
          .trim();
      if (includeReceipt && link != null) {
        try {
          final receipt = await CBEReceiptParser().parseReceipt(link);
          parsedMessage = {...parsedMessage, ...receipt};
        } catch (e) {
          print(
              'Error parsing receipt: $e includeReceipt: $includeReceipt and link: $link');
        }
      } else {
        print(
            'Receipt parsing disabled or link is null: includeReceipt: $includeReceipt and link: $link');
      }
      print('Parsed message: $parsedMessage');
      return parsedMessage;
    } catch (e) {
      print('Error parsing message: $e and Parsed Message: $parsedMessage');
      return null;
    }
  }

  static DateTime? parseDate(String date) {
    try {
      final parts = date.split(', ');
      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');
      final hour = timeParts[0];
      final minute = timeParts[1].split(' ')[0];
      final period = timeParts[1].split(' ')[1];
      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        period == 'PM' ? int.parse(hour) + 12 : int.parse(hour),
        int.parse(minute),
      );
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  Future<Map<String, String>> parseReceipt(String link) async {
    Map<String, String> response = {};
    final client = CBEHttpClient();
    try {
      final text = await client.readPDF(link);
      var prevText = '';
      text.split('\n').forEach((line) {
        if (prevText.contains('Payer')) {
          response['payer'] = line.trim();
        }
        if (prevText.contains('Account')) {
          if (response['payerAccount'] == null) {
            response['payerAccount'] = line.trim();
          } else {
            response['receiverAccount'] = line.trim();
          }
        }
        if (prevText.contains('Receiver')) {
          response['receiver'] = line.trim();
        }
        if (prevText.contains('Account')) {
          response['receiverAccount'] = line.trim();
        }
        if (prevText.contains('Reference No. (VAT Invoice No)')) {
          response['referenceNo'] = line.trim();
        }
        if (prevText.contains('Reason / Type of service')) {
          response['reason'] = line.trim();
          // split by 'via' and get the last part as a channel
          response['channel'] = line.split('via').last.trim();
        }
        if (prevText.contains('Transferred Amount')) {
          response['transferredAmount'] =
              line.replaceAll(',', '').replaceAll('ETB', '').trim();
        }
        if (prevText.contains('Commission or Service Charge')) {
          response['serviceFee'] =
              line.replaceAll(',', '').replaceAll('ETB', '').trim();
        }
        if (prevText.contains('15% VAT on Commission')) {
          response['vat'] =
              line.replaceAll(',', '').replaceAll('ETB', '').trim();
        }
        if (prevText.contains('Total amount debited from customers account')) {
          response['totalAmount'] =
              line.replaceAll(',', '').replaceAll('ETB', '').trim();
        }
        prevText = line.trim();
      });
    } catch (e) {
      print('Error parsing receipt: $e');
    }
    return response;
  }
}
