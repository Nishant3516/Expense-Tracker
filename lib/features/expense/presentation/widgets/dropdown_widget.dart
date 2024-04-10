import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T)? itemText;
  final void Function(T?) onChanged;
  final InputDecoration decoration;

  const DropdownWidget({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemText,
    this.decoration = const InputDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemText != null ? itemText!(item) : item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: decoration,
    );
  }
}
