import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muday/src/models/transaction.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:muday/src/utils/helpers.dart';

class TransactionDetail extends StatelessWidget {
  final TransactionCls transaction;

  const TransactionDetail({
    super.key,
    required this.transaction,
  });

  // Future<void> _launchPdfUrl() async {

  //   if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }
  Future<void> _launchPdfUrl() async {
    try {
      // TODO: if transaction.referenceNumber is null, show a snackbar
      final url = Uri.parse(transaction.pdfLink);
      print('launching URL: $url');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Transaction: ${transaction.toMap()}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Transaction Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // use ctx
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: Center(
                      child: Icon(
                        transaction.wallet == TransactionWallet.CBE
                            ? Icons.account_balance
                            : Icons.phone_android,
                        size: 32,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: transaction.wallet == TransactionWallet.CBE
                          ? Colors.blue[50]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      transaction.wallet.toString().split('.').last,
                      style: TextStyle(
                        color: transaction.wallet == TransactionWallet.CBE
                            ? Colors.blue
                            : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    birrFormatter.format(transaction.total),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  DetailRow(
                    label: 'Payer',
                    value: transaction.payer ?? 'N/A',
                  ),
                  DetailRow(
                    label: 'Payer Account',
                    value: transaction.payerAccount ?? 'N/A',
                  ),
                  DetailRow(
                    label: 'Receiver',
                    value: transaction.receiver ?? 'N/A',
                  ),
                  DetailRow(
                    label: 'Receiver Account',
                    value: transaction.receiverAccount ?? 'N/A',
                  ),
                  if (transaction.status != null)
                    DetailRow(
                      label: 'Status',
                      value: transaction.status.toString().split('.').last,
                      valueColor:
                          transaction.status == TransactionStatus.COMPLETED
                              ? Colors.green
                              : Colors.red,
                    ),
                  DetailRow(
                    label: 'Amount',
                    value: birrFormatter.format(transaction.amount),
                  ),
                  if (transaction.serviceFee != null &&
                      transaction.serviceFee! > 0)
                    DetailRow(
                      label: 'Service Fee',
                      value: birrFormatter.format(transaction.serviceFee!),
                    ),
                  if (transaction.vat != null && transaction.vat! > 0)
                    DetailRow(
                      label: 'VAT',
                      value: birrFormatter.format(transaction.vat!),
                    ),
                  if (transaction.stampDuty != null &&
                      transaction.stampDuty! > 0)
                    DetailRow(
                      label: 'Stamp Duty',
                      value: birrFormatter.format(transaction.stampDuty!),
                    ),
                  if (transaction.discount != null && transaction.discount! > 0)
                    DetailRow(
                      label: 'Discount',
                      value: '- ${birrFormatter.format(transaction.discount!)}',
                      valueColor: Colors.green,
                    ),
                  const Divider(height: 32),
                  DetailRow(
                    label: 'Total',
                    value: birrFormatter.format(transaction.total),
                    isBold: true,
                  ),
                  DetailRow(
                    label: 'Reference Number',
                    value: transaction.referenceNumber ?? 'N/A',
                  ),
                  DetailRow(
                    label: 'Reason',
                    value: transaction.reason ?? 'N/A',
                  ),
                  DetailRow(
                    label: 'Channel',
                    value: transaction.channel ?? 'N/A',
                  ),
                  DetailRow(
                    label: 'Date & Time',
                    value: transaction.date == null
                        ? 'N/A'
                        : DateFormat('MMM dd, yyyy hh:mm a')
                            .format(transaction.date!),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _launchPdfUrl,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.download),
                label: const Text('Download Receipt'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
