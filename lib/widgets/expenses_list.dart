import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e/model/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  Widget build(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('expenses')
          .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
            'Oh O! No Expenses here try adding some.',
            style: GoogleFonts.spaceMono(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (ctx, index) {
            final data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final timestamp = data['date'] as Timestamp;
            final date = timestamp.toDate();

            return Dismissible(
              key: ValueKey(snapshot.data!.docs[index].id),
              direction: DismissDirection.horizontal,

              onDismissed: (direction) async {
                final deletedDoc = snapshot.data!.docs[index];
                final deletedData = deletedDoc.data() as Map<String, dynamic>;

                await FirebaseFirestore.instance
                    .collection('expenses')
                    .doc(snapshot.data!.docs[index].id)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('expenses')
                            .doc(deletedDoc.id)
                            .set(deletedData);
                      },
                    ),
                    content: Row(children: [Text('Expense deleted'), Spacer()]),
                  ),
                );
                // No need to call setState; StreamBuilder updates automatically!
              },
              child: Card(
                color: Colors.black,
                elevation: 10,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                60,
                                118,
                                118,
                                118,
                              ).withValues(alpha: .25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: data['image'] != null
                                ? Image.file(data['image']!, fit: BoxFit.cover)
                                : Text('No Image'),
                          ),
                        ),
                      ),
                      Text(
                        data['name'],
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            data['amount'].toString(),
                            style: GoogleFonts.spaceMono(color: Colors.white),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                CategoryIcons[Catogary.values.firstWhere(
                                  (c) => c.name == data['category'],
                                  orElse: () => Catogary.food,
                                )],
                                color: Colors.white,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '${date.day}/${date.month}/${date.year}',
                                style: GoogleFonts.spaceMono(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
