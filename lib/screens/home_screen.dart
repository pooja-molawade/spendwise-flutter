import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';
import 'package:spendwise_flutter/screens/profile/analytics_screen.dart';
import 'package:spendwise_flutter/screens/profile/profile_screen.dart';
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
      appBar: AppBar(
        title:  Text(
          context.l10n.appName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person,color: Colors.white,),
            onPressed: () {
              final bloc = context.read<ExpenseBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: const ProfileScreen(),
                  ),
                ),
              );
            },
          ),
        ],),
      body: SafeArea(
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            final expenses = state.expenses;

            final total = state.expenses.fold(
              0.0,
                  (sum, e) => sum + e.amount,
            );
            final categorySummary = _groupByCategory(expenses);
            final grouped = _groupByDate(expenses);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                _balanceCard(total),
                _sectionTitle(context.l10n.spendingInsights),
                _insightsSection(state.expenses),
                const SizedBox(height: 20),
                _categoryChips(categorySummary),
                const SizedBox(height: 10),
                _analyticsCTA(context),
                _sectionTitle(context.l10n.recentTransactions),
                Expanded(child: _transactionList(grouped)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6A5AE0),
        onPressed: () {
          final bloc = context.read<ExpenseBloc>();
          showModalBottomSheet(
            context: context,
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: const QuickAddSheet(),
            ),
          );
        },
        icon: const Icon(Icons.add,color: Colors.white,),
        label:  Text(context.l10n.add,style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _balanceCard(double total) {
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
            blurRadius: 12,
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

  Widget _categoryChips(Map<String, double> data) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: data.entries.map((e) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEBFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("${e.key} ₹${e.value.toInt()}"),
          );
        }).toList(),
      ),
    );
  }

  Widget _analyticsCTA(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.viewAnalytics),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        final bloc = context.read<ExpenseBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: const AnalyticsScreen(),
            ),
          ),
        );
      },
    );
  }

  Widget _transactionList(Map<String, List> grouped) {
    return ListView(
      shrinkWrap: true,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                entry.key,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...entry.value.map((e) {
              return ListTile(
                title: Text(e.title),
                subtitle: Text(e.category),
                trailing: Text("₹${e.amount}"),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Widget _insightsSection(List expenses) {
    final insights = InsightService.generate(expenses,context);
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
              color: insight.color.withValues(alpha: 0.1),
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
  Map<String, double> _groupByCategory(List expenses) {
    final Map<String, double> data = {};
    for (var e in expenses) {
      data[e.category] =
          (data[e.category] ?? 0) + e.amount;
    }
    return data;
  }

  Map<String, List> _groupByDate(List expenses) {
    final Map<String, List> data = {};
    for (var e in expenses) {
      final now = DateTime.now();
      final diff = now.difference(e.date).inDays;
      String key;
      if (diff == 0) {
        key = context.l10n.today;
      } else if (diff == 1) {
        key = context.l10n.yesterday;
      } else {
        key = "${e.date.day}/${e.date.month}";
      }
      data.putIfAbsent(key, () => []).add(e);
    }
    return data;
  }
}