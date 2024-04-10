import 'package:expensetracker/features/expense/data/data_sources/expense_local_datasource.dart';
import 'package:expensetracker/features/expense/data/models/expense_model.dart';
import 'package:expensetracker/features/expense/data/repository/expense_repository_impl.dart';
import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';
import 'package:expensetracker/features/expense/domain/usecases/add_expense.dart';
import 'package:expensetracker/features/expense/domain/usecases/delete_expense.dart';
import 'package:expensetracker/features/expense/domain/usecases/get_expenses.dart';
import 'package:expensetracker/features/expense/domain/usecases/update_expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final localDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
  final Box<ExpenseModel> expenseBox = Hive.box('expenses');
  return ExpenseLocalDataSource(expenseBox);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final localDataSource = ref.read(localDataSourceProvider);
  return ExpenseRepositoryImpl(localDataSource);
});

final addExpenseProvider = Provider<AddExpenseUseCase>((ref) {
  final repository = ref.read(expenseRepositoryProvider);
  return AddExpenseUseCase(repository);
});

final deleteExpenseProvider = Provider<DeleteExpenseUseCase>((ref) {
  final repository = ref.read(expenseRepositoryProvider);
  return DeleteExpenseUseCase(repository);
});

final getExpenseProvider = Provider<GetExpenseUseCase>((ref) {
  final repository = ref.read(expenseRepositoryProvider);
  return GetExpenseUseCase(repository);
});

final updateExpenseProvider = Provider<UpdateExpenseUseCase>((ref) {
  final repository = ref.read(expenseRepositoryProvider);
  return UpdateExpenseUseCase(repository);
});

final expenseListNotifierProvider =
    StateNotifierProvider<ExpenseListNotifier, List<Expense>>((ref) {
  final getExpenses = ref.read(getExpenseProvider);
  final addExpense = ref.read(addExpenseProvider);
  final deleteExpense = ref.read(deleteExpenseProvider);
  final updateExpense = ref.read(updateExpenseProvider);

  return ExpenseListNotifier(
      getExpenses, addExpense, deleteExpense, updateExpense);
});

class ExpenseListNotifier extends StateNotifier<List<Expense>> {
  final GetExpenseUseCase _getExpenses;
  final AddExpenseUseCase _addExpense;
  final DeleteExpenseUseCase _deleteExpense;
  final UpdateExpenseUseCase _updateExpense;

  ExpenseListNotifier(this._getExpenses, this._addExpense, this._deleteExpense,
      this._updateExpense)
      : super([]);

  Future<void> addNewExpense(Expense expense) async {
    await _addExpense(expense);
  }

  Future<void> removeExpense(int id) async {
    await _deleteExpense(id);
  }

  Future<void> updateExistingExpense(int id, Expense expense) async {
    await _updateExpense(id, expense);
  }

  Future<void> loadExpenses() async {
    final expenses = await _getExpenses();
    state = expenses;
  }
}
