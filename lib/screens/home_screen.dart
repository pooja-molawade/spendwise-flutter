import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../bottomsheets/quick_add_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("SpendWise 💰"),
        elevation: 1,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          final total = state.expenses.fold(
            0.0,
                (sum, e) => sum + e.amount,
          );
          return Column(
            children: [
              _balanceCard(total),
              _chartSection(state.expenses),
              _recentTransactions(state.expenses),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<ExpenseBloc>().add(
          //   AddExpense("Coffee", 120),
          // );
          showModalBottomSheet(
            context: context,
            builder: (_) => const QuickAddSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _balanceCard(double total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.green],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Balance",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            "₹ ${total.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartSection(List expenses) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: total, width: 20)
            ]),
          ],
        ),
      ),
    );
  }
  Widget _recentTransactions(List expenses) {
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (_, i) {
          final e = expenses[i];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.money)),
            title: Text(e.title),
            trailing: Text("₹${e.amount}"),
          );
        },
      ),
    );
  }
}