Schema for Transactions

## Transaction

### CBE Transaction

data i can get from the sms[always available]
- id [Required, String]: Unique identifier for the transaction.
- amount [Required, Number]: Amount of the transaction.
- service_fee [Number]: Service fee for the transaction.
- vat [Number]: Value-added tax for the transaction.
- total [Required, Number]: Total amount of the transaction.
- date [Required, Date]: Date of the transaction.

pdf parse[based on the user preference so all are optional]

- payer [String]: Payer of the transaction.
- PayerAccount [String]: Account of the transaction.
- Receiver [String]: Receiver of the transaction.
- ReceiverAccount [String]: Account of the transaction.
- Reason [String]: Reason for the transaction.

### Telebirr Transaction

data i can get from the sms[always available]
- id [Required, String]: Unique identifier for the transaction.
- amount [Required, Number]: Amount of the transaction.
- service_fee [Number]: Service fee for the transaction.
- vat [Number]: Value-added tax for the transaction.

pdf parse [based on the user preference so all are optional]
- payer [String]: Payer of the transaction.
- PayerAccount [String]: Account of the transaction.
- payer_account_type [String]: Account type of the payer.
- payer_tin_number [String]: TIN number of the payer.
- Receiver [String]: Receiver of the transaction.
- ReceiverAccount [String]: Account of the transaction.
- status [String]: Status of the transaction.
- stamp_duty [Number]: Stamp duty for the transaction.
- discount [Number]: Discount for the transaction.
- channel [String]: Channel of the transaction.