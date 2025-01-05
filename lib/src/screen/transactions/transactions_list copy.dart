import 'package:flutter/material.dart';
import 'package:muday/src/data/data.dart';
import 'package:muday/src/utils/helpers.dart';
import 'package:muday/src/utils/types.dart';

class TransactionListView extends StatelessWidget {
  const TransactionListView({super.key});

  String _getGroupTitle(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // if (difference.inDays == 0) return 'Today';
    // if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return 'This week';
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
    if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    }
    return '${(difference.inDays / 365).floor()} years ago';
  }

  @override
  Widget build(BuildContext context) {
    // Group transactions by date
    final groupedTransactions = <String, List<Transaction>>{};

    for (var transaction in sampleTransactions) {
      final group = _getGroupTitle(transaction.dateTime);
      groupedTransactions.putIfAbsent(group, () => []);
      groupedTransactions[group]!.add(transaction);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Financial Report Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'See your financial report',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          // Transactions List
          Expanded(
            child: ListView.builder(
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final group = groupedTransactions.keys.elementAt(index);
                final transactions = groupedTransactions[group]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        group,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ...transactions.map((transaction) => TransactionListItem(
                          transaction: transaction,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/transaction-details',
                              arguments: {'transaction': transaction},
                            );
                          },
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: transaction.isExpense
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  transaction.icon,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(width: 12),
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    transaction.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            // Amount and Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isExpense ? "-" : "+"} \$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction.isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  humanReadableDate(transaction.dateTime),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
