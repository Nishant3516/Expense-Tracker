import 'package:expensetracker/features/expense/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(int id);
  Future<void> updateExpense(int id, Expense expense);
}
