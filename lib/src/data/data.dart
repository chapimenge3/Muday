


import 'package:muday/src/utils/types.dart';

final List<Transaction> sampleTransactions = [
  Transaction(
    id: '1',
    title: 'Shopping',
    description: 'Buy some grocery',
    amount: 120.00,
    dateTime: DateTime.now(),
    category: 'Shopping',
    icon: '🛍️',
    isExpense: true,
  ),
  Transaction(
    id: '2',
    title: 'Subscription',
    description: 'Disney+ Annual Plan',
    amount: 80.00,
    dateTime: DateTime.now().subtract(Duration(hours: 1)),
    category: 'Entertainment',
    icon: '📱',
    isExpense: true,
  ),
  Transaction(
    id: '3',
    title: 'Buy Phone',
    description: 'Buy a Samsung S24 Ultra',
    amount: 145_000.00,
    dateTime: DateTime.now().subtract(Duration(hours: 3)),
    category: 'Utilities',
    icon: '📱',
    isExpense: true,
  ),
  Transaction(
    id: '4',
    title: 'Salary',
    description: 'Salary for July',
    amount: 5000.00,
    dateTime: DateTime.now().subtract(Duration(hours: 12)),
    category: 'Income',
    icon: '💰',
    isExpense: false,
  ),
  Transaction(
    id: '5',
    title: 'Transportation',
    description: 'Charging Tesla',
    amount: 18.00,
    dateTime: DateTime.now().subtract(Duration(days: 1)),
    category: 'Transport',
    icon: '🚗',
    isExpense: true,
  ),
  Transaction(
    id: '6',
    title: 'Buy House',
    description: 'Buy a new house',
    amount: 1_500_000.00,
    dateTime: DateTime.now().subtract(Duration(days: 4)),
    category: 'Housing',
    icon: '🏠',
    isExpense: true,
  ),
  // ... Add more sample transactions
] + List.generate(14, (index) => Transaction(
    id: (index + 7).toString(),
    title: ['Coffee', 'Lunch', 'Dinner', 'Movies', 'Shopping', 'Gas', 'Internet'][index % 7],
    description: 'Transaction description',
    amount: (index + 1) * 10.0,
    dateTime: DateTime.now().subtract(Duration(days: (index + 1) * 7)),
    category: ['Food', 'Entertainment', 'Transport', 'Utilities'][index % 4],
    icon: ['☕', '🍽️', '🎬', '🛒', '⛽', '🌐'][index % 6],
    isExpense: true,
  ));



