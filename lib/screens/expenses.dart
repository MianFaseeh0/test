import 'package:e/model/data.dart';
import 'package:e/screens/new_expense.dart';
import 'package:e/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:e/widgets/expenses_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _Expensesstate();
  }
}

class _Expensesstate extends State<Expenses> {
  void openExpenseOverlay() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => NewExpense()));
  }

  // void _removeexpense(Expense expense) {
  //   final expenseindex = _registeredExpense.indexOf(expense);
  //   setState(() {
  //     _registeredExpense.remove(expense);
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 4),
  //       content: const Text('Expense deleted'),
  //       action: SnackBarAction(
  //         label: 'undo',
  //         onPressed: () {
  //           setState(() {
  //             _registeredExpense.insert(expenseindex, expense);
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Expense Tracker',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: openExpenseOverlay,
            icon: Icon(Icons.add, size: 25),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 300,

            left: 16,
            right: 16,
            child: Image.asset('assets/json/homepage_background.png'),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 5,
            bottom: 450,
            child: Hero(
              tag: 'hello',
              child: Lottie.asset(
                'assets/json/gradient.json',
                height: 200,
                width: 200,
              ),
            ),
          ),
          Positioned(
            top: .1,
            bottom: .1,
            right: .1,
            left: .1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: const Chart(),
                ),
                const SizedBox(height: 10),

                Expanded(child: ExpensesList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
