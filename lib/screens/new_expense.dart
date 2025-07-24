import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:e/model/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpensestate();
  }
}

class _NewExpensestate extends State<NewExpense> {
  DateTime _selectedDate = DateTime.now();

  final _NameController = TextEditingController();
  final _AmountController = TextEditingController();

  final _fromkey = GlobalKey<FormState>();

  var isSending = false;
  Catogary _selectedCatogary = Catogary.games;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(now.year - 20, now.month, now.day),
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate!;
    });
  }

  @override
  void dispose() {
    _NameController.dispose();
    _AmountController.dispose();
    super.dispose();
  }

  Future<void> uploadExpenses() async {
    if (_fromkey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });

      try {
        await FirebaseFirestore.instance.collection('expenses').add({
          'name': _NameController.text.trim(),
          'date': _selectedDate,
          'amount': int.parse(_AmountController.text.trim()),
          'category': _selectedCatogary.name,
          'user': FirebaseAuth.instance.currentUser!.uid,
        });

        if (!mounted) {
          return;
        }

        Navigator.of(context).pop();

        setState(() {
          isSending = false;
        });

        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          msg: 'Expense Added',
          gravity: ToastGravity.BOTTOM,
        );
      } catch (e) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new Expense')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _fromkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _NameController,
                    decoration: InputDecoration(label: Text('Name of Expense')),
                    maxLength: 50,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _AmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text('Enter Amount'),
                            prefixText: '\$',
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null) {
                              return 'must be a value';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(formater.format(_selectedDate)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: _selectedCatogary,
                    items: Catogary.values
                        .map(
                          (catogary) => DropdownMenuItem(
                            value: catogary,
                            child: Text(catogary.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCatogary = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await uploadExpenses();
                      },
                      child: Text(
                        'submit',
                        style: GoogleFonts.spaceMono(color: Colors.black),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'cancel',
                        style: GoogleFonts.spaceMono(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSending)
            Container(
              color: const Color.fromARGB(112, 0, 0, 0),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
