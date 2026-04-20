import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import 'load_expenses_event.dart';
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseService service;
  final String userId;

  ExpenseBloc(this.service, this.userId) : super(ExpenseState()) {
    on<LoadExpenses>((event, emit) async {
      await emit.forEach<List<Expense>>(
        service.getExpenses(userId),
        onData: (expenses) {
          return state.copyWith(expenses: expenses, error: '');
        },
      );
    });

    on<AddExpense>((event, emit) async {
      try {
        final expense = Expense(
          id: '',
          title: event.title,
          amount: event.amount,
          category: event.category,
          date: DateTime.now(),
        );

        await service.addExpense(expense, userId);
      } catch (e) {
        debugPrint('Error while adding $e');
      }
    });

    on<DeleteExpense>((event, emit) async {
      try {
        await service.deleteExpense(event.id);
      } catch (e) {
        emit(state.copyWith(error: "Failed to delete"));
      }
    });
  }
}