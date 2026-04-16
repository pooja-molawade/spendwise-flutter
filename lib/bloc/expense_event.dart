abstract class ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final String title;
  final double amount;
  final String category;

  AddExpense(this.title, this.amount,this.category);
}

class DeleteExpense extends ExpenseEvent {
  final String id;

  DeleteExpense(this.id);
}