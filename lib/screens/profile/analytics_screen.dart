import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendwise_flutter/bloc/expense_bloc.dart';
import 'package:spendwise_flutter/bloc/expense_state.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';

import '../../bloc/expense_event.dart';

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
            return  Center(child: Text(context.l10n.noDataAvailable));
          }

          final total = expenses.fold<double>(
              0, (sum, e) => sum + e.amount);

          final categoryData = _groupByCategory(expenses);
          return Column(
            children: [
              const SizedBox(height: 20),
              _filters(context, state.selectedFilter),
              const SizedBox(height: 20),
              _balanceCard(total,context),
              _budgetCard(total, 100000),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _legend(categoryData),
                    Expanded(child: _pieChart(categoryData)),
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
    final total = data.values.reduce((a, b) => a + b);

    final colors = [
      Color(0xFF6A5AE0),
      Color(0xFF8E7CFF),
      Color(0xFF00BFA6),
      Color(0xFFFFB300),
      Color(0xFFFF7043),
    ];

    return AspectRatio(
      aspectRatio: 1.0,
      child: PieChart(
        PieChartData(
          sections: data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;

            final percentage = (e.value / total) * 100;

            return PieChartSectionData(
              color: colors[index % colors.length],
              value: e.value,
              title:
                   "${percentage.toStringAsFixed(0)}%"
                 ,
              radius:65,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 55,

        ),
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

  Widget _filters(BuildContext context, String selected) {
    final filters = ["Week", "Month", "Year"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((f) {
          final isSelected = f == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (_) {
                context.read<ExpenseBloc>().add(FilterChanged(f));
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _budgetCard(double spent, double budget) {
    final percent = spent / budget;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueAccent.withValues(alpha: 0.1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Budget", style: TextStyle(color: Colors.black)),
          const SizedBox(height: 8),
          Text("₹$spent / ₹$budget",
              style: const TextStyle(color: Colors.black, fontSize: 20)),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white24,
            color: percent > 0.8 ? Colors.red : Colors.green,
          ),

          const SizedBox(height: 8),

          Text(
            percent > 1
                ? "⚠ Budget exceeded"
                : "₹${(budget - spent).toStringAsFixed(0)} left",
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _trendChart(List<FlSpot> spots) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: false),
            )
          ],
        ),
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