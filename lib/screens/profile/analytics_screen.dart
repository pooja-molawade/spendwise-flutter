import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendwise_flutter/bloc/expense_bloc.dart';
import 'package:spendwise_flutter/bloc/expense_state.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title:  Text(context.l10n.analytics,
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,
        titleSpacing: 0,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          final expenses = state.expenses;

          if (expenses.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final total = expenses.fold<double>(
              0, (sum, e) => sum + e.amount);

          final categoryData = _groupByCategory(expenses);
          return Column(
            children: [
              const SizedBox(height: 20),
              _balanceCard(total,context),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _pieChart(categoryData)),
                    _legend(categoryData),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _balanceCard(double total,BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A5AE0).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(context.l10n.totalSpent,
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

  Widget _pieChart(Map<String, double> data) {
    final colors = [
      Color(0xFF6A5AE0),
      Color(0xFF8E7CFF),
      Color(0xFF00BFA6),
      Color(0xFFFFB300),
      Color(0xFFFF7043),
    ];

    return PieChart(
      PieChartData(
        sections: data.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: e.value,
            title: "",
            radius: 60,
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _legend(Map<String, double> data) {
    final colors = [
      Color(0xFF6A5AE0),
      Color(0xFF8E7CFF),
      Color(0xFF00BFA6),
      Color(0xFFFFB300),
      Color(0xFFFF7043),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: data.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 5),
              Text(e.key),
            ],
          );
        }).toList(),
      ),
    );
  }

  Map<String, double> _groupByCategory(List expenses) {
    final Map<String, double> data = {};

    for (var e in expenses) {
      data[e.category] = (data[e.category] ?? 0) + e.amount;
    }

    return data;
  }
}