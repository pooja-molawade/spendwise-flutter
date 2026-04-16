import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise_flutter/screens/home_screen.dart';

import 'bloc/expense_bloc.dart';

void main() {
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ExpenseBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}

