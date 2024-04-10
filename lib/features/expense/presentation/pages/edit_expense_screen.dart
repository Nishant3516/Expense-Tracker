import 'package:expensetracker/features/expense/domain/entities/expense.dart';
import 'package:expensetracker/features/expense/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final Expense expense;
  const EditExpenseScreen({required this.expense, Key? key}) : super(key: key);

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final List<String> categories = ["Food", "Travel", "Shopping"];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    // Initialize text controllers with expense details
    _amountController.text = widget.expense.amount.toString();
    _descController.text = widget.expense.description;
    _startDateController.text =
        DateFormat('E, MMM d, yyyy').format(widget.expense.date);
    _selectedCategory = widget.expense.category;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Expense"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              buildDateRow(context),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedExpense = Expense(
                      id: widget.expense.id,
                      amount: double.parse(_amountController.text),
                      date: DateFormat('E, MMM d, yyyy')
                          .parse(_startDateController.text),
                      description: _descController.text,
                      category: (_selectedCategory == null)
                          ? categories[0]
                          : _selectedCategory!,
                    );
                    ref
                        .read(expenseListNotifierProvider.notifier)
                        .updateExistingExpense(
                            widget.expense.id!, updatedExpense);
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _startDateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: const InputDecoration(
              labelText: 'Date',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDateController.value) {
      setState(() {
        _startDateController.text = DateFormat('E, MMM d, yyyy').format(picked);
      });
    }
  }
}
