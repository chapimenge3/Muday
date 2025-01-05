import 'package:flutter/material.dart';
import 'package:muday/src/screen/home/recent_transactions.dart';
import 'package:muday/src/utils/helpers.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            // Add refresh logic if needed
            // test refresh to sleep for 2 seconds
            await Future.delayed(const Duration(seconds: 1));

            // show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Refreshed successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green), // must be transparent
                  // style: Theme.of(context).,
                ),
                duration: Duration(seconds: 1),
                // backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
          child: Column(
            children: [
              _buildHeader(context),
              // const SizedBox(height: 20),
              // _buildWalletBalanceSection(context),
              // const SizedBox(height: 20),
              // _buildIncomeExpenseCards(context),
              // const SizedBox(height: 20),
              // const Expanded(child: RecentTransactions()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _buildWalletBalanceSection(context),
                    const SizedBox(height: 20),
                    _buildIncomeExpenseCards(context),
                    const SizedBox(height: 20),
                    _buildTransactionsSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: const RecentTransactions(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/settings'),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0xFF29756F), width: 2),
                      ),
                    ),
                  ),
                  Icon(Icons.person_2,
                      color: Theme.of(context).colorScheme.outline),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _buildWalletBalanceSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'My Wallets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final wallets = [
                  (
                    'CBE',
                    'Commercial Bank of Ethiopia',
                    50000.0,
                    Icons.account_balance,
                    Theme.of(context).colorScheme.primary
                  ),
                  (
                    'Abyssinia',
                    'Bank of Abyssinia',
                    25000.0,
                    Icons.account_balance,
                    Theme.of(context).colorScheme.secondary
                  ),
                  (
                    'Cash',
                    'Physical Cash',
                    10000.0,
                    Icons.wallet,
                    Theme.of(context).colorScheme.tertiary
                  ),
                ];

                return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == 2 ? 16 : 8,
                  ),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: _buildWalletCard(
                    context,
                    wallets[index].$1,
                    wallets[index].$2,
                    wallets[index].$3,
                    wallets[index].$4,
                    wallets[index].$5,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, String name, String description,
      double balance, IconData icon, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color),
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            '${humanReadableNumber(balance)} ETB',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('See Details'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFinanceCard(
                  context,
                  'Income',
                  100000.42,
                  Icons.trending_up_rounded,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildFinanceCard(
                  context,
                  'Expense',
                  45000.0,
                  Icons.trending_down_rounded,
                  Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 45000.0 / 100000.42,
            backgroundColor: Colors.green.withValues(alpha: 30),
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard(BuildContext context, String title, double amount,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${humanReadableNumber(amount)} ETB',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
