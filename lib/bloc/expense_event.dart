abstract class ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final String title;
  final double amount;

  AddExpense(this.title, this.amount);
}

class DeleteExpense extends ExpenseEvent {
  final String id;

  DeleteExpense(this.id);
}