import 'package:expensetracker/features/expense/data/data_sources/expense_local_datasource.dart';
import 'package:expensetracker/features/expense/data/models/expense_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockExpenseBox extends Mock implements Box<ExpenseModel> {}

void main() {
  late ExpenseLocalDataSource dataSource;
  late MockExpenseBox mockExpenseBox;

  setUp(() {
    mockExpenseBox = MockExpenseBox();
    dataSource = ExpenseLocalDataSource(mockExpenseBox);
  });

  group('getExpenses', () {
    test('should return list of ExpenseModel from Hive Box', () {
      // Arrange
      final expenses = [
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
      when(mockExpenseBox.values).thenReturn(expenses);

      // Act
      final result = dataSource.getExpenses();

      // Assert
      expect(result, equals(expenses));
    });
  });

  group('addExpense', () {
    test('should add ExpenseModel to Hive Box', () {
      // Arrange
      final expenseToAdd = ExpenseModel(
          id: 1,
          amount: 10.0,
          date: DateTime.now(),
          description: 'Test',
          category: 'Test');

      // Act
      dataSource.addExpense(expenseToAdd);

      // Assert
      verify(mockExpenseBox.add(expenseToAdd)).called(1);
    });
  });

  group('deleteExpense', () {
    test('should delete ExpenseModel from Hive Box by id', () {
      // Arrange
      const idToDelete = 1;

      // Act
      dataSource.deleteExpense(idToDelete);

      // Assert
      verify(mockExpenseBox.delete(idToDelete)).called(1);
    });
  });

  group('updateExpense', () {
    test('should update ExpenseModel in Hive Box with given id', () {
      // Arrange
      const idToUpdate = 1;
      final updatedExpense = ExpenseModel(
          id: idToUpdate,
          amount: 20.0,
          date: DateTime.now(),
          description: 'Updated',
          category: 'Updated');

      // Act
      dataSource.updateExpense(idToUpdate, updatedExpense);

      // Assert
      verify(mockExpenseBox.put(idToUpdate, updatedExpense)).called(1);
    });
  });
}
