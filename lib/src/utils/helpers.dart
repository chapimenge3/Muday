import 'package:intl/intl.dart';

String humanReadableDate(dynamic date) {
  DateTime dateTime;

  if (date is String) {
    dateTime = DateTime.parse(date);
  } else if (date is DateTime) {
    dateTime = date;
  } else {
    throw ArgumentError('Invalid date format');
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    if (difference.inMinutes == 0) {
      return 'Just now';
    } else if (difference.inHours == 0) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours > 0 && difference.inHours < 12) {
      return '${difference.inHours} hours ago';
    }
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 14) {
    return 'Last week';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return DateFormat.yMMMMd().format(dateTime);
  }
}

String humanReadableNumber(num number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return number.toString();
  }
}

var birrFormatter = NumberFormat.currency(
    symbol: 'Br. ', decimalDigits: 2, customPattern: '###,###.00 Br.');
