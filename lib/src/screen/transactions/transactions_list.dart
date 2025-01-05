import 'package:flutter/material.dart';
import 'package:muday/src/models/transaction.dart';
import 'package:muday/src/screen/transactions/transactions_list_item.dart';
import 'package:muday/src/services/transactions/transaction_service.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key});

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  final _transactionService = TransactionService();
  final ScrollController _scrollController = ScrollController();
  List<TransactionCls> _transactions = [];
  bool _isLoading = true;
  int _currentOffset = 0;
  static const int _pageSize = 20;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _loadMoreTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    try {
      print('Loading initial transactions');
      // if last transaction
      final transactions = await _transactionService.getAllTransactions(
        offset: _currentOffset,
        count: _pageSize,
      );
      print('Loaded transactions: ${transactions.length}');
      setState(() {
        _transactions = transactions;
        _isLoading = false;
        _currentOffset += (_currentPage * _pageSize) + 1;
        _currentPage++;
      });
      print('Current Offset: $_currentOffset and Current Page: $_currentPage');
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore) {
      print('Already loading more transactions');
      return;
    }

    try {
      setState(() {
        _isLoadingMore = true;
      });

      // Create a temporary list to hold new transactions
      final moreTransactions = await _transactionService.getAllTransactions(
        offset: _currentOffset,
        count: _pageSize,
      );
      print('Got: ${moreTransactions.length} transactions');

      // Only update state once with all changes
      if (mounted) {
        setState(() {
          // Use List.addAll() on a new list to avoid concurrent modification
          final newTransactions = List<TransactionCls>.from(_transactions)
            ..addAll(moreTransactions);

          // Update the state variables
          _transactions.clear();
          _transactions.addAll(newTransactions);
          _currentOffset += moreTransactions.length;
          _isLoadingMore = false;
          print('Current Offset: $_currentOffset');
          print('Current Transactions: ${_transactions.length}');
        });
      }
    } catch (e) {
      print('_loadMoreTransactions Error: ${e.toString()}');
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  String _getGroupTitle(DateTime? date) {
    if (date == null) return 'All transactions';
    final now = DateTime.now();
    final difference = now.difference(date);

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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final groupedTransactions = <String, List<TransactionCls>>{};
    for (var transaction in _transactions) {
      final group = _getGroupTitle(transaction.date);
      groupedTransactions.putIfAbsent(group, () => []);
      groupedTransactions[group]!.add(transaction);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
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
                Icon(Icons.chevron_right, color: Colors.purple),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                if (index == groupedTransactions.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: _isLoadingMore
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: _loadMoreTransactions,
                              child: const Text('Load More'),
                            ),
                    ),
                  );
                }

                final group = groupedTransactions.keys.elementAt(index);
                final transactions = groupedTransactions[group]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
