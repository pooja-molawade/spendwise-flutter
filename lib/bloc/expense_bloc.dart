import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseState()) {
    on<AddExpense>((event, emit) {
      final newExpense = Expense(
        id: DateTime.now().toString(),
        title: event.title,
        amount: event.amount,
      );

      emit(
        state.copyWith(
          expenses: [...state.expenses, newExpense],
        ),
      );
    });

    on<DeleteExpense>((event, emit) {
      emit(
        state.copyWith(
          expenses: state.expenses
              .where((e) => e.id != event.id)
              .toList(),
        ),
      );
    });
  }
}