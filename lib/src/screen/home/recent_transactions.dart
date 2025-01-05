import 'package:flutter/material.dart';
import 'package:muday/src/app.dart';
import 'package:muday/src/models/transaction.dart';
import 'package:muday/src/screen/transactions/transactions_list_item.dart';
import 'package:muday/src/services/transactions/transaction_service.dart';
import 'package:muday/src/utils/helpers.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final _transactionService = TransactionService();
  List<TransactionCls> transactions = [];
  bool _isLoading = true;
  Map<String, List<TransactionCls>> groupedTransactions = {};

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final fetchedTransactions =
          await _transactionService.getAllTransactions(count: 5);
      setState(() {
        transactions = fetchedTransactions;
        _isLoading = false;
        _groupTransactions();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error appropriately
      print('Error loading transactions: $e');
    }
  }

  void _groupTransactions() {
    groupedTransactions = {};
    for (var transaction in transactions) {
      final date = humanReadableDate(transaction.date);
      groupedTransactions.putIfAbsent(date, () => []).add(transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _buildTransactionHeader(context),
        const SizedBox(height: 20),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  itemCount: groupedTransactions.length,
                  itemBuilder: (context, index) {
                    final date = groupedTransactions.keys.elementAt(index);
                    final dateTransactions = groupedTransactions[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (index == 0)
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, '/transactions'),
                                  child: GestureDetector(
                                    onTap: () => Navigator.restorablePushNamed(
                                        context, Routes.transactionList),
                                    child: Text(
                                      'View All',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ...dateTransactions
                            .map((transaction) => TransactionListItem(
                                  transaction: transaction,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/transaction-details',
                                    arguments: {'transaction': transaction},
                                  ),
                                )),
                      ],
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildTransactionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transactions History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/transactions'),
          child: GestureDetector(
            onTap: () =>
                Navigator.restorablePushNamed(context, Routes.transactionList),
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
