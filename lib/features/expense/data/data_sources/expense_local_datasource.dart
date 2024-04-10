import 'package:expensetracker/features/expense/data/models/expense_model.dart';
import 'package:hive/hive.dart';

class ExpenseLocalDataSource {
  final Box<ExpenseModel> expenseBox;
  const ExpenseLocalDataSource(this.expenseBox);

  List<ExpenseModel> getExpenses() {
    return expenseBox.values.toList();
  }

  void addExpense(ExpenseModel expense) {
    expenseBox.add(expense);
  }

  void deleteExpense(int id) {
    expenseBox.delete(id);
  }

  void updateExpense(int id, ExpenseModel expense) {
    expenseBox.put(id, expense);
  }
}
