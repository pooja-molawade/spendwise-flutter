import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';
import '../bloc/load_expenses_event.dart';
import '../bottomsheets/quick_add_sheet.dart';
import '../services/insights.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(title: Text('💰 SpendWise ',style: TextStyle(color: Colors.white),),backgroundColor:Colors.teal,),
      body: SafeArea(
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            final total = state.expenses.fold(
              0.0,
                  (sum, e) => sum + e.amount,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(height: 20,),
                _balanceCard(total),
                _sectionTitle("Spending Insights"),
                _insightsSection(state.expenses),
                _pieChart(state.expenses),
                _sectionTitle("Recent Transactions"),
                _recentTransactions(state.expenses),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (bottomSheetContext) {
              return BlocProvider.value(
                value: context.read<ExpenseBloc>(),
                child: const QuickAddSheet(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ================= BALANCE =================
  Widget _balanceCard(double total) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.tealAccent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Spent",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            "₹ ${total.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= CHART =================
  Widget _pieChart(List expenses) {
    final Map<String, double> data = {};

    for (var e in expenses) {
      data[e.category] =
          (data[e.category] ?? 0) + e.amount;
    }

    return Expanded(
      child: PieChart(
        PieChartData(
          sections: data.entries.map((e) {
            return PieChartSectionData(
              value: e.value,
              title: e.key,
            );
          }).toList(),
        ),
      ),
    );
  }

  // ================= TRANSACTIONS =================
  Widget _recentTransactions(List expenses) {
    if (expenses.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No expenses yet 😴"),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: expenses.length,
        itemBuilder: (_, i) {
          final e = expenses[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.money, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    e.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  "₹${e.amount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _insightsSection(List expenses) {
    final insights = InsightService.generate(expenses);

    if (insights.isEmpty) return const SizedBox();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        itemBuilder: (_, i) {
          final insight = insights[i];

          return Container(
            width: 250,
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(insight.icon, color: insight.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    insight.message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}