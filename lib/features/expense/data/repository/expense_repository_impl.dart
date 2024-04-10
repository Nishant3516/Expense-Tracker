import 'package:expensetracker/features/expense/data/data_sources/expense_local_datasource.dart';
import 'package:expensetracker/features/expense/data/models/expense_model.dart';
import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  const ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<List<Expense>> getExpenses() async {
    final List<ExpenseModel> expenseModels = localDataSource.getExpenses();
    return expenseModels
        .map((expenseModel) => expenseModel.toEntity())
        .toList();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    localDataSource.addExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense(int id) async {
    localDataSource.deleteExpense(id);
  }

  @override
  Future<void> updateExpense(int id, Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    localDataSource.updateExpense(id, expenseModel);
  }
}
