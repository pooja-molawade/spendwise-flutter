import '../models/expense.dart';

class ExpenseState {
  final List<Expense> expenses;

  ExpenseState({this.expenses = const []});

  ExpenseState copyWith({List<Expense>? expenses}) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
    );
  }
}