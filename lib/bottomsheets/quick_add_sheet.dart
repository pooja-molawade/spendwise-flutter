import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final amountController = TextEditingController();
  String selectedCategory = "Food";

  final categories = ["Food", "Travel", "Bills", "Shopping"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Amount Field
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                hintText: "Enter amount ₹",
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 10),

            // Category Chips
            Wrap(
              spacing: 8,
              children: categories.map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: selectedCategory == c,
                  onSelected: (_) {
                    setState(() => selectedCategory = c);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Add Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount =
                      double.tryParse(amountController.text) ?? 0;

                  context.read<ExpenseBloc>().add(
                    AddExpense(
                      "Quick Expense",
                      amount,
                        selectedCategory
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Add Expense"),
              ),
            )
          ],
        ),
      ),
    );
  }
}