import 'package:expensetracker/features/expense/data/data_sources/expense_local_datasource.dart';
import 'package:expensetracker/features/expense/data/models/expense_model.dart';
import 'package:expensetracker/features/expense/data/repository/expense_repository_impl.dart';
import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpenseLocalDataSource extends Mock
    implements ExpenseLocalDataSource {}

void main() {
  late ExpenseRepositoryImpl repository;
  late MockExpenseLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockExpenseLocalDataSource();
    repository = ExpenseRepositoryImpl(mockLocalDataSource);
  });

  group('getExpenses', () {
    test('should return List<Expense>', () async {
      // Arrange
      final mockExpenseModels = [
        ExpenseModel(
            id: 1,
            amount: 10.0,
            date: DateTime.now(),
            description: 'Test',
            category: 'Test'),
        ExpenseModel(
            id: 2,
            amount: 20.0,
            date: DateTime.now(),
            description: 'Test',
            category: 'Test'),
      ];
      when(mockLocalDataSource.getExpenses()).thenReturn(mockExpenseModels);

      // Act
      final result = await repository.getExpenses();

      // Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals(1));
      expect(result[1].id, equals(2));
    });
  });

  group('addExpense', () {
    test('should add an expense', () async {
      // Arrange
      final expense = Expense(
          id: 1,
          amount: 10.0,
          date: DateTime.now(),
          description: 'Test',
          category: 'Test');

      // Act
      await repository.addExpense(expense);

      // Assert
      verify(mockLocalDataSource.addExpense(ExpenseModel.fromEntity(expense)))
          .called(1);
    });
  });

  group('deleteExpense', () {
    test('should delete an expense by id', () async {
      // Arrange
      const idToDelete = 1;

      // Act
      await repository.deleteExpense(idToDelete);

      // Assert
      verify(mockLocalDataSource.deleteExpense(idToDelete)).called(1);
    });
  });

  group('updateExpense', () {
    test('should update an expense', () async {
      // Arrange
      const idToUpdate = 1;
      final expense = Expense(
          id: 1,
          amount: 20.0,
          date: DateTime.now(),
          description: 'Updated',
          category: 'Updated');

      // Act
      await repository.updateExpense(idToUpdate, expense);

      // Assert
      verify(mockLocalDataSource.updateExpense(
              idToUpdate, ExpenseModel.fromEntity(expense)))
          .called(1);
    });
  });
}
