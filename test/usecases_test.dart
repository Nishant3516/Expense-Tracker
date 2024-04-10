import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/domain/repository/expense_repository.dart';
import 'package:expensetracker/features/expense/domain/usecases/add_expense.dart';
import 'package:expensetracker/features/expense/domain/usecases/delete_expense.dart';
import 'package:expensetracker/features/expense/domain/usecases/get_expenses.dart';
import 'package:expensetracker/features/expense/domain/usecases/update_expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late AddExpenseUseCase addExpenseUseCase;
  late DeleteExpenseUseCase deleteExpenseUseCase;
  late UpdateExpenseUseCase updateExpenseUseCase;
  late GetExpenseUseCase getExpensesUseCase;
  late MockExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    addExpenseUseCase = AddExpenseUseCase(mockExpenseRepository);
    deleteExpenseUseCase = DeleteExpenseUseCase(mockExpenseRepository);
    updateExpenseUseCase = UpdateExpenseUseCase(mockExpenseRepository);
    getExpensesUseCase = GetExpenseUseCase(mockExpenseRepository);
  });

  test('should add expense to repository', () async {
    // Arrange
    final expense = Expense(
        id: 1,
        amount: 10.0,
        date: DateTime.now(),
        description: 'Test',
        category: 'Test');

    // Act
    await addExpenseUseCase(expense);

    // Assert
    verify(mockExpenseRepository.addExpense(expense)).called(1);
  });

  test('should delete expense from repository', () async {
    // Arrange
    const idToDelete = 1;

    // Act
    await deleteExpenseUseCase(idToDelete);

    // Assert
    verify(mockExpenseRepository.deleteExpense(idToDelete)).called(1);
  });

  test('should update expense in repository', () async {
    // Arrange
    const idToUpdate = 1;
    final expense = Expense(
        id: 1,
        amount: 20.0,
        date: DateTime.now(),
        description: 'Updated',
        category: 'Updated');

    // Act
    await updateExpenseUseCase(idToUpdate, expense);

    // Assert
    verify(mockExpenseRepository.updateExpense(idToUpdate, expense)).called(1);
  });

  test('should get expenses from repository', () async {
    // Arrange
    final mockExpenses = [
      Expense(
          id: 1,
          amount: 10.0,
          date: DateTime.now(),
          description: 'Test',
          category: 'Test'),
      Expense(
          id: 2,
          amount: 20.0,
          date: DateTime.now(),
          description: 'Test',
          category: 'Test'),
    ];
    when(mockExpenseRepository.getExpenses())
        .thenAnswer((_) => Future.value(mockExpenses));

    // Act
    final result = await getExpensesUseCase();

    // Assert
    expect(result, equals(mockExpenses));
  });
}
