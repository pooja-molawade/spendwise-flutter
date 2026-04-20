import '../models/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final String error;

  ExpenseState({this.expenses = const [],this.error=''});

  ExpenseState copyWith({List<Expense>? expenses, required String error}) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      error :error,
    );
  }
}