import '../models/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final String error;
  final String selectedFilter;

  ExpenseState({this.expenses = const [],this.error='',this.selectedFilter = "Month",});

  ExpenseState copyWith({List<Expense>? expenses, required String error, String selectedFilter=''}) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      error :error,
      selectedFilter: selectedFilter,
    );
  }
}