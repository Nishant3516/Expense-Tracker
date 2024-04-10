import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  const DeleteExpenseUseCase(this._expenseRepository);

  Future<void> call(int id) {
    return _expenseRepository.deleteExpense(id);
  }
}
