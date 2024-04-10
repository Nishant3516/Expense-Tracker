import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class SummaryScreen extends StatelessWidget {
  final List<Expense> expenses;
  const SummaryScreen({
    super.key,
    required this.expenses,
  });

  Map<String, double> calculateExpenseSummary(
      DateTime startDate, DateTime endDate) {
    Map<String, double> summaries = {};
    expenses.forEach((expense) {
      summaries[expense.category] = 0;
    });

    List<Expense> filteredExpenses = expenses.where((expense) {
      return expense.date.isAfter(startDate) &&
          expense.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    filteredExpenses.forEach((expense) {
      summaries[expense.category] =
          summaries[expense.category]! + expense.amount;
    });

    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime startDateWeekly = currentDate.subtract(const Duration(days: 6));
    DateTime startDateMonthly =
        DateTime(currentDate.year, currentDate.month, 1);

    Map<String, double> weeklyExpense =
        calculateExpenseSummary(startDateWeekly, currentDate);
    Map<String, double> monthlyExpense =
        calculateExpenseSummary(startDateMonthly, currentDate);
    Map<String, double> totalExpense =
        calculateExpenseSummary(DateTime(2022), currentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Summary'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildPieChart(context, 'Weekly Expense', weeklyExpense,
              startDateWeekly, currentDate),
          _buildPieChart(context, 'Monthly Expense', monthlyExpense,
              startDateMonthly, currentDate),
          _buildPieChart(context, 'Total Expense', totalExpense, DateTime(2022),
              currentDate),
        ],
      ),
    );
  }

  Widget _buildPieChart(
      BuildContext context,
      String title,
      Map<String, double> expenseSummary,
      DateTime startDate,
      DateTime endDate) {
    Map<String, Color> colorMap = {
      'Food': Colors.blue,
      'Shopping': Colors.green,
      'Travel': Colors.orange,
      // Add more categories and colors as needed
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(
              "${DateFormat("MMM d, yyyy").format(startDate)} - ${DateFormat("MMM d, yyyy").format(endDate)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PieChart(
            dataMap: expenseSummary,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2,
            initialAngleInDegree: 0,
            chartType: ChartType.disc,
            ringStrokeWidth: 32,
            centerText: "Expenses",
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
            ),
            colorList: colorMap.values.toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
