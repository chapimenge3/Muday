class TransactionCls {
  final String id;
  final TransactionWallet wallet; // enum: CBE, TELEBIRR
  final TransactionType type; // enum: DEBITED, CREDITED
  final double amount;
  final double? serviceFee;
  final double? vat;
  final DateTime? date;
  final String? referenceNumber;

  // Common optional fields from PDF
  final String? payer;
  final String? payerAccount;
  final String? receiver;
  final String? receiverAccount;
  final String? reason;

  // TeleBirr specific fields
  final String? payerAccountType;
  final String? payerTinNumber;
  final TransactionStatus? status;
  final double? stampDuty;
  final double? discount;
  final String? channel;

  // Computed fields
  double get total =>
      amount +
      (serviceFee ?? 0) +
      (vat ?? 0) +
      (stampDuty ?? 0) -
      (discount ?? 0);

  TransactionCls({
    required this.id,
    required this.wallet,
    required this.type,
    required this.amount,
    required this.date,
    this.serviceFee,
    this.vat,
    this.referenceNumber,
    this.payer,
    this.payerAccount,
    this.receiver,
    this.receiverAccount,
    this.reason,
    this.payerAccountType,
    this.payerTinNumber,
    this.status,
    this.stampDuty,
    this.discount,
    this.channel,
  });

  // SQLite converter
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wallet': wallet.toString(),
      'type': type.toString(),
      'amount': amount,
      'service_fee': serviceFee,
      'vat': vat,
      'date': date?.toIso8601String(),
      'reference_number': referenceNumber,
      'payer': payer,
      'payer_account': payerAccount,
      'receiver': receiver,
      'receiver_account': receiverAccount,
      'reason': reason,
      'payer_account_type': payerAccountType,
      'payer_tin_number': payerTinNumber,
      'status': status?.toString(),
      'stamp_duty': stampDuty,
      'discount': discount,
      'channel': channel,
    };
  }

  // Firebase converter
  Map<String, dynamic> toJson() => toMap();

  // Factory constructor for SQLite
  factory TransactionCls.fromMap(Map<String, dynamic> map) {
    return TransactionCls(
      id: map['id'] ?? '',
      wallet: TransactionWallet.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => TransactionWallet.CBE,
      ),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => TransactionType.DEBITED,
      ),
      amount: map['amount'] ?? 0.0,
      serviceFee: map['service_fee'] ?? 0.0,
      vat: map['vat'] ?? 0.0,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      referenceNumber: map['reference_number'] ?? '',
      payer: map['payer'] ?? '',
      payerAccount: map['payer_account'] ?? '',
      receiver: map['receiver'] ?? '',
      receiverAccount: map['receiver_account'] ?? '',
      reason: map['reason'] ?? '',
      payerAccountType: map['payer_account_type'] ?? '',
      payerTinNumber: map['payer_tin_number'] ?? '',
      status: map['status'] != null
          ? TransactionStatus.values.firstWhere(
              (e) => e.toString() == map['status'],
              orElse: () => TransactionStatus.PENDING,
            )
          : TransactionStatus.PENDING,
      stampDuty: map['stamp_duty'] ?? 0.0,
      discount: map['discount'] ?? 0.0,
      channel: map['channel'] ?? '',
    );
  }

  // Factory constructor for Firebase
  factory TransactionCls.fromJson(Map<String, dynamic> json) =>
      TransactionCls.fromMap(json);

  // write me a method to calculate the PDF link of the transaction based on the reference number
  // if the transaction is CBE, the link should be https://apps.cbe.com.et:100/?id=referenceNumber
  // if the transaction is TeleBirr, the link should be https://transactionsinfo.ethiotelecom.et/receipt/referenceNumber
  String get pdfLink {
    if (wallet == TransactionWallet.CBE) {
      return 'https://apps.cbe.com.et:100/?id=$referenceNumber';
    } else {
      return 'https://transactionsinfo.ethiotelecom.et/receipt/$referenceNumber';
    }
  }
}

final transactionDbCreateQuery = '''CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        wallet TEXT NOT NULL,
        amount REAL NOT NULL,
        service_fee REAL,
        vat REAL,
        date DATETIME NOT NULL,
        reference_number TEXT,
        payer TEXT,
        payer_account TEXT,
        receiver TEXT,
        receiver_account TEXT,
        reason TEXT,
        payer_account_type TEXT,
        payer_tin_number TEXT,
        status TEXT,
        stamp_duty REAL,
        discount REAL,
        channel TEXT,
        user_id TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
''';

enum TransactionWallet { CBE, TELEBIRR }

enum TransactionStatus { PENDING, COMPLETED, FAILED, CANCELLED }

enum TransactionType { DEBITED, CREDITED }
