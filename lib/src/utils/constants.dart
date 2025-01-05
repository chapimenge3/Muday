import 'package:flutter/material.dart';

const Map<String, Map<String, dynamic>> currencies = {
  'ETB': {
    'name': 'Ethiopian Birr',
    'symbol': 'Br',
    'icon': Text('ብር', style: TextStyle(fontSize: 12)),
  },
  'USD': {
    'name': 'US Dollar',
    'symbol': '\$',
    'icon': Icons.attach_money,
  },
  'EUR': {
    'name': 'Euro',
    'symbol': '€',
    'icon': Icons.euro,
  },
  'GBP': {
    'name': 'British Pound',
    'symbol': '£',
    'icon': Icons.money,
  },
  'JPY': {
    'name': 'Japanese Yen',
    'symbol': '¥',
    'icon': Icons.money_off,
  },
  'INR': {
    'name': 'Indian Rupee',
    'symbol': '₹',
    'icon': Icons.currency_rupee,
  },
  'CAD': {
    'name': 'Canadian Dollar',
    'symbol': 'C\$',
    'icon': Icons.attach_money,
  },
  'AUD': {
    'name': 'Australian Dollar',
    'symbol': 'A\$',
    'icon': Icons.attach_money,
  },
};
