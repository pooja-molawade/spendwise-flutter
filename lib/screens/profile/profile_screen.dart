import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';
import 'package:spendwise_flutter/main.dart';
import 'package:spendwise_flutter/screens/auth/login_screen.dart';
import 'package:spendwise_flutter/screens/profile/all_expense_screen.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_state.dart';
import 'analytics_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF8E7CFF), Color(0xFF6A5AE0)],),
          ),
        ), elevation: 0,),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.email ?? context.l10n.noEmail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${context.l10n.uid}: ${user?.uid.substring(0, 8) ?? ''}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  final total = state.expenses.fold<double>(
                    0,
                        (sum, e) => sum + e.amount,
                  );
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFF3F1FF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                         Text(
                         context.l10n.totalSpending,
                          style: TextStyle(color: Color(0xFF6A5AE0)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹ $total",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B3FD3),

                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTile(
                    icon: Icons.history,
                    title:context.l10n.viewAllExpenses,
                    color: Colors.blue,
                    onTap: () {
                      final bloc = context.read<ExpenseBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: bloc,
                            child: const AllExpensesScreen(),
                          ),
                        ),
                      );
                    },
                  ),

                  _buildTile(
                    icon: Icons.analytics,
                    title:context.l10n.analytics,
                    color: Colors.orange,
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
                  ),
                  _buildTile(
                    icon: Icons.settings,
                    title: context.l10n.settings,
                    color: Colors.purple,
                    onTap: () {},
                  ),

                  _buildTile(
                    icon: Icons.language,
                    title: context.l10n.language,
                    color: Colors.blueAccent,
                    onTap: () {
                      _showLanguageBottomSheet(context);
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout,color: Colors.white,),
                      label:  Text(context.l10n.logout,style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5AE0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if(context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
               context.l10n.select_language,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _languageTile(context, "English", const Locale('en')),
              _languageTile(context, "हिंदी", const Locale('hi')),
              _languageTile(context, "मराठी", const Locale('mr')),
            ],
          ),
        );
      },
    );
  }
  Widget _languageTile(BuildContext context, String title, Locale locale) {
    return ListTile(
      title: Text(title),
      onTap: () {
        SpendWiseApp.setLocale(context, locale);
        Navigator.pop(context);
      },
    );
  }
  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}