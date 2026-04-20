import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_event.dart';
import '../../bloc/expense_state.dart';

class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("All Expenses",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,titleSpacing: 0,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          final expenses = state.expenses;

          if (expenses.isEmpty) {
            return const Center(child: Text("No expenses found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final e = expenses[index];

              return Dismissible(
                key: Key(e.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child:
                  const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<ExpenseBloc>().add(
                    DeleteExpense(e.id),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text(e.title),
                    subtitle: Text(
                        "${e.category} • ${e.date.day}/${e.date.month}"),
                    trailing: Text(
                      "₹${e.amount}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}