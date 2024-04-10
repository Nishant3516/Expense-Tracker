import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final double amount;
  final DateTime date;
  final String description;
  final String category;

  const Expense({
    this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });

  @override
  List<Object?> get props {
    return [id, amount, date, description, category];
  }
}
