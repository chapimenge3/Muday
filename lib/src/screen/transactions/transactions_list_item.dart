import 'package:flutter/material.dart';
import 'package:muday/src/models/transaction.dart';
import 'package:muday/src/utils/helpers.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionCls transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.type == TransactionType.DEBITED;
    String title;
    if (transaction.type == TransactionType.CREDITED) {
      title = transaction.payer ?? 'Unknown Sender';
      if (title.isEmpty) {
        title = 'Unknown Sender';
      }
    } else {
      title = transaction.receiver ?? 'Unknown Receiver';
      if (title.isEmpty) {
        title = 'Unknown Receiver';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: isExpense ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  isExpense
                      ? Icons.arrow_circle_up_outlined
                      : Icons.arrow_circle_down_outlined,
                  color: isExpense ? Colors.red : Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    transaction.reason ?? 'Transaction',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ETB ${humanReadableNumber(transaction.amount)}',
                  style: TextStyle(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.date.toString().substring(0, 16),
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
