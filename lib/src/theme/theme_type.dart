import 'package:flutter/material.dart';

// Custom Theme Extension
@immutable
class ExpenseThemeExtension extends ThemeExtension<ExpenseThemeExtension> {
  const ExpenseThemeExtension({
    required this.incomeColor,
    required this.expenseColor,
    required this.savingsColor,
    required this.budgetColor,
    required this.transactionTileColor,
    required this.chartLineColor,
    required this.customShadow,
    required this.successGradient,
    required this.dangerGradient,
  });

  final Color incomeColor;
  final Color expenseColor;
  final Color savingsColor;
  final Color budgetColor;
  final Color transactionTileColor;
  final Color chartLineColor;
  final BoxShadow customShadow;
  final LinearGradient successGradient;
  final LinearGradient dangerGradient;

  @override
  ExpenseThemeExtension copyWith({
    Color? incomeColor,
    Color? expenseColor,
    Color? savingsColor,
    Color? budgetColor,
    Color? transactionTileColor,
    Color? chartLineColor,
    BoxShadow? customShadow,
    LinearGradient? successGradient,
    LinearGradient? dangerGradient,
  }) {
    return ExpenseThemeExtension(
      incomeColor: incomeColor ?? this.incomeColor,
      expenseColor: expenseColor ?? this.expenseColor,
      savingsColor: savingsColor ?? this.savingsColor,
      budgetColor: budgetColor ?? this.budgetColor,
      transactionTileColor: transactionTileColor ?? this.transactionTileColor,
      chartLineColor: chartLineColor ?? this.chartLineColor,
      customShadow: customShadow ?? this.customShadow,
      successGradient: successGradient ?? this.successGradient,
      dangerGradient: dangerGradient ?? this.dangerGradient,
    );
  }

  @override
  ExpenseThemeExtension lerp(
      ThemeExtension<ExpenseThemeExtension>? other, double t) {
    if (other is! ExpenseThemeExtension) {
      return this;
    }
    return ExpenseThemeExtension(
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      savingsColor: Color.lerp(savingsColor, other.savingsColor, t)!,
      budgetColor: Color.lerp(budgetColor, other.budgetColor, t)!,
      transactionTileColor:
          Color.lerp(transactionTileColor, other.transactionTileColor, t)!,
      chartLineColor: Color.lerp(chartLineColor, other.chartLineColor, t)!,
      customShadow: BoxShadow.lerp(customShadow, other.customShadow, t)!,
      successGradient:
          LinearGradient.lerp(successGradient, other.successGradient, t)!,
      dangerGradient:
          LinearGradient.lerp(dangerGradient, other.dangerGradient, t)!,
    );
  }
}
// Light theme values

const lightTheme = ExpenseThemeExtension(
  incomeColor: Color(0xFF4CAF50),
  expenseColor: Color(0xFFE53935),
  savingsColor: Color(0xFF2196F3),
  budgetColor: Color(0xFFFF9800),
  transactionTileColor: Color(0xFFFAFAFA),
  chartLineColor: Color(0xFF2196F3),
  customShadow: BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
  successGradient: LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  dangerGradient: LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);

// Dark theme values
const darkTheme = ExpenseThemeExtension(
  incomeColor: Color(0xFF81C784),
  expenseColor: Color(0xFFE57373),
  savingsColor: Color(0xFF64B5F6),
  budgetColor: Color(0xFFFFB74D),
  transactionTileColor: Color(0xFF2D2D2D),
  chartLineColor: Color(0xFF90CAF9),
  customShadow: BoxShadow(
    color: Color(0x3A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
  successGradient: LinearGradient(
    colors: [Color(0xFF81C784), Color(0xFFA5D6A7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  dangerGradient: LinearGradient(
    colors: [Color(0xFFE57373), Color(0xFFEF9A9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);


// Modified AppTheme class to include the extension
// class AppTheme {
  // static ThemeData lightTheme() {
  //   return ThemeData.light().copyWith(
  //     // Your existing theme configurations...
  //     extensions: const [
  //       ExpenseThemeExtension.light,
  //     ],
  //   );
  // }

  // static ThemeData darkTheme() {
  //   return ThemeData.dark().copyWith(
  //     // Your existing theme configurations...
  //     extensions: const [
  //       ExpenseThemeExtension.dark,
  //     ],
  //   );
  // }
// }

// // Example usage in a widget
// class TransactionTile extends StatelessWidget {
//   final bool isIncome;
//   final String amount;
//   final String title;

//   const TransactionTile({
//     required this.isIncome,
//     required this.amount,
//     required this.title,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Get the custom theme extension
//     final customTheme = Theme.of(context).extension<ExpenseThemeExtension>()!;

//     return Container(
//       decoration: BoxDecoration(
//         color: customTheme.transactionTileColor,
//         boxShadow: [customTheme.customShadow],
//         gradient:
//             isIncome ? customTheme.successGradient : customTheme.dangerGradient,
//       ),
//       child: ListTile(
//         title: Text(title),
//         trailing: Text(
//           amount,
//           style: TextStyle(
//             color:
//                 isIncome ? customTheme.incomeColor : customTheme.expenseColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
