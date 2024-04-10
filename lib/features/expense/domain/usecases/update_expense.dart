import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  const UpdateExpenseUseCase(this._expenseRepository);

  Future<void> call(int id, Expense expense) {
    return _expenseRepository.updateExpense(id, expense);
  }
}
