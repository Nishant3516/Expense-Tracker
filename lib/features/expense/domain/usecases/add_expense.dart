import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  const AddExpenseUseCase(this._expenseRepository);

  Future<void> call(Expense expense) {
    return _expenseRepository.addExpense(expense);
  }
}
