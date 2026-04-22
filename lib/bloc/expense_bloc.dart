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
        emit(state.copyWith(error: "Failed to delete",));
      }
    });

    on<FilterChanged>((event, emit) {
      List<Expense>? filteredExpenses = _applyFilter(event.filter);

      emit(state.copyWith(
        expenses: filteredExpenses,
        selectedFilter: event.filter, error: 'Failed to filter out.',
      ));
    });

  }

  List<Expense> _applyFilter(String filter) {
    final now = DateTime.now();

    switch (filter) {
      case "Week":
        return state.expenses.where((e) =>
            e.date.isAfter(now.subtract(const Duration(days: 7)))).toList();

      case "Month":
        return state.expenses.where((e) =>
        e.date.month == now.month &&
            e.date.year == now.year).toList();

      case "Year":
        return state.expenses.where((e) =>
        e.date.year == now.year).toList();

      default:
        return state.expenses;
    }
  }
}