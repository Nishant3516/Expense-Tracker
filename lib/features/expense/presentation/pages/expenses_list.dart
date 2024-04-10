import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/presentation/pages/add_expense_screen.dart';
import 'package:expensetracker/features/expense/presentation/pages/edit_expense_screen.dart';
import 'package:expensetracker/features/expense/presentation/pages/summarize_expenses.dart';
import 'package:expensetracker/features/expense/presentation/providers/expense_provider.dart';
import 'package:expensetracker/features/expense/presentation/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpensesListScreen extends ConsumerWidget {
  const ExpensesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(expenseListNotifierProvider.notifier).loadExpenses();
    final expensesList = ref.watch(expenseListNotifierProvider);

    final groupedExpenses = groupExpensesByDate(expensesList);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            tooltip: "Summary",
            child: const Icon(Icons.summarize_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryScreen(expenses: expensesList),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            tooltip: "Add Expense",
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: groupedExpenses.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final expenseDate = groupedExpenses.keys.toList()[index];
            final expenses = groupedExpenses[expenseDate]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("------------------  "),
                      Text(
                        DateFormat.yMMMEd().format(expenseDate).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text("  ------------------"),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ExpenseCard(
                      category: expense.category,
                      amount: expense.amount,
                      description: expense.description,
                      date: DateFormat.yMMMEd().format(expense.date).toString(),
                      onEdit: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditExpenseScreen(
                              expense: expensesList[index],
                            ),
                          ),
                        );
                      },
                      onDelete: () {
                        ref
                            .read(expenseListNotifierProvider.notifier)
                            .removeExpense(index);
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Map<DateTime, List<Expense>> groupExpensesByDate(List<Expense> expenses) {
    final groupedExpenses = <DateTime, List<Expense>>{};

    for (final expense in expenses) {
      final date =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (!groupedExpenses.containsKey(date)) {
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }

    // Sort keys (dates) in descending order
    final sortedKeys = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Create a new map with sorted keys
    final Map<DateTime, List<Expense>> sortedGroupedExpenses = Map.fromIterable(
        sortedKeys,
        key: (key) => key,
        value: (key) => groupedExpenses[key]!);

    return sortedGroupedExpenses;
  }
}
