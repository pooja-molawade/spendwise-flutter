import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
/*
class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final amountController = TextEditingController();
  String selectedCategory = "Food";

  final categories = ["Food", "Travel", "Bills", "Shopping","EMI"];

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
                        selectedCategory,
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
}*/
class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  double amount = 0;
  String selectedCategory = "Food";


  final quickAmounts = [50, 100, 200, 500];
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categories = [context.l10n.food, "Travel", "Bills", "Shopping", "EMI"];

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: "₹ 0",
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: quickAmounts.map((amt) {
              return ActionChip(
                label: Text("₹$amt"),
                onPressed: () {
                  final current =
                      double.tryParse(amountController.text) ?? 0;
                  final newAmount = current + amt;

                  amountController.text = newAmount.toStringAsFixed(0);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: categories.map((c) {
              final isSelected = selectedCategory == c;
              return ChoiceChip(
                checkmarkColor: Colors.white,
                label: Text(c),
                selected: isSelected,
                selectedColor: const Color(0xFF6A5AE0),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                onSelected: (_) {
                  setState(() => selectedCategory = c);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                final amount =
                    double.tryParse(amountController.text) ?? 0;

                if (amount == 0) return;

                context.read<ExpenseBloc>().add(
                  AddExpense(
                    "Quick Expense",
                    amount,
                    selectedCategory,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text(
                "Add Expense",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}