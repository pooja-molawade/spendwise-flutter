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
  String selected = "Food";
  String amount = "";

  final categories = ["Food", "Travel", "Shopping", "Bills"];

  void addDigit(String digit) {
    setState(() {
      amount += digit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Amount Display
            Text(
              "₹ $amount",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            const SizedBox(height: 16),
      
            // 🔹 Category Chips
            Wrap(
              spacing: 8,
              children: categories.map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: selected == c,
                  onSelected: (_) {
                    setState(() => selected = c);
                  },
                );
              }).toList(),
            ),
      
            const SizedBox(height: 16),
      
            // 🔢 Number Pad
            GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, i) {
                final num = (i + 1).toString();
                return InkWell(
                  onTap: () => addDigit(num),
                  child: Center(child: Text(num, style: const TextStyle(fontSize: 20))),
                );
              },
            ),
      
            const SizedBox(height: 10),
      
            ElevatedButton(
              onPressed: () {
                if (amount.isEmpty) return;
                context.read<ExpenseBloc>().add(
                  AddExpense(selected, double.parse(amount)),
                );
      
                Navigator.pop(context);
              },
              child: const Text("Add Expense"),
            )
          ],
        ),
      ),
    );
  }
}