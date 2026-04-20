import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise_flutter/screens/auth/login_screen.dart';
import 'package:spendwise_flutter/screens/home_screen.dart';
import 'package:spendwise_flutter/services/expense_service.dart';

import 'bloc/expense_bloc.dart';
import 'bloc/load_expenses_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData) {
            return const LoginScreen();
          }

          final user = snapshot.data!;
          return BlocProvider(
            create: (_) => ExpenseBloc(
              ExpenseService(),
              user.uid,
            )..add(LoadExpenses()),
            child: const HomeScreen(),
          );
        },
      ),
    );
  }
}
