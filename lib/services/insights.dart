import 'package:flutter/material.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';

import '../models/insight.dart';

class InsightService {
  static List<Insight> generate(List expenses,BuildContext context) {
    if (expenses.isEmpty) return [];

    final List<Insight> insights = [];

    final now = DateTime.now();

    // ---------------- TOTAL ----------------
    final total =
    expenses.fold(0.0, (sum, e) => sum + e.amount);

    // ---------------- CATEGORY ANALYSIS ----------------
    final Map<String, double> categoryTotal = {};

    for (var e in expenses) {
      categoryTotal[e.category] =
          (categoryTotal[e.category] ?? 0) + e.amount;
    }

    // Top category
    final topCategory = categoryTotal.entries.reduce(
          (a, b) => a.value > b.value ? a : b,
    );

    final percent =
    ((topCategory.value / total) * 100).toStringAsFixed(0);

    insights.add(
      Insight(
        message:
            context.l10n.spendingPercentage(topCategory.key, percent),
        icon: Icons.pie_chart,
        color: Colors.blue,
      ),
    );

    // ---------------- TODAY SPENDING ----------------
    final todayExpenses = expenses.where((e) {
      return e.date.day == now.day &&
          e.date.month == now.month &&
          e.date.year == now.year;
    }).toList();

    final todayTotal =
    todayExpenses.fold(0.0, (s, e) => s + e.amount);

    if (todayTotal > 1000) {
      insights.add(
        Insight(
          message: context.l10n.highSpendingToday(todayTotal),
          icon: Icons.warning,
          color: Colors.red,
        ),
      );
    }

    // ---------------- WEEK TREND ----------------
    final weekAgo = now.subtract(const Duration(days: 7));

    final lastWeekTotal = expenses
        .where((e) => e.date.isAfter(weekAgo))
        .fold(0.0, (s, e) => s + e.amount);

    if (lastWeekTotal > 0) {
      insights.add(
        Insight(
          message: context.l10n.last7DaysSpending(lastWeekTotal),
          icon: Icons.trending_up,
          color: Colors.green,
        ),
      );
    }

    return insights;
  }
}