import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import 'load_expenses_event.dart';
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseService service;

  ExpenseBloc(this.service) : super(ExpenseState()) {

    on<LoadExpenses>((event, emit) async {
      await emit.forEach<List<Expense>>(
        service.getExpenses(),
        onData: (expenses) {
          return state.copyWith(expenses: expenses);
        },
      );
    });

    on<AddExpense>((event, emit) async {
      final expense = Expense(
        id: '',
        title: event.title,
        amount: event.amount,
        category: event.category,
        date: DateTime.now(),
      );

      await service.addExpense(expense);
    });

    on<DeleteExpense>((event, emit) async {
      await service.deleteExpense(event.id);
    });
  }
}