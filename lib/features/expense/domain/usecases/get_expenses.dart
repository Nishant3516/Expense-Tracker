import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';

class GetExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  const GetExpenseUseCase(this._expenseRepository);

  Future<List<Expense>> call() {
    return _expenseRepository.getExpenses();
  }
}
