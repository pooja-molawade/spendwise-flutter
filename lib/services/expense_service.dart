import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense.dart';

class ExpenseService {
  final _db = FirebaseFirestore.instance;

  Future<void> addExpense(Expense expense) async {
    await _db.collection("expenses").add(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _db.collection("expenses").doc(id).delete();
  }

  Stream<List<Expense>> getExpenses() {
    return _db
        .collection("expenses")
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}