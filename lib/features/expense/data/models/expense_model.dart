import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String category;

  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
        id: expense.id ?? 0,
        amount: expense.amount,
        date: expense.date,
        description: expense.description,
        category: expense.category);
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      date: date,
      description: description,
      category: category,
    );
  }
}
